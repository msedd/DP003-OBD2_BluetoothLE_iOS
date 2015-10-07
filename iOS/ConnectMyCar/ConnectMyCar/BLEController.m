//
//  BLEController.m
//  BluetoothLE_Tester
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "BLEController.h"

@implementation BLEController

+ (BLEController *)sharedController
{
    static BLEController *controller = nil;
    if (controller == nil) {
        controller = [[BLEController alloc] init];
    }
    
    return controller;
}

- (id)init{
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey: @"myCentralManagerIdentifier" }];
    self.updatedValueSignal  = [RACSubject subject];
    self.leConnectedSignal  = [RACSubject subject];
    return  self;
}

/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    /*
     [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
     options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
     */
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"Scanning started");
}
- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"BLE update state");
    if(self.discoveredPeripheral != nil)
        [central connectPeripheral:self.discoveredPeripheral options:nil];
    else
        [self scan];
}

- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)state {
    
    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    NSLog(@"willRestoreState %@ %@",state,peripherals);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // Reject any where the value is above reasonable range
    if (RSSI.integerValue > -15) {
        NSLog(@"ignore peripheral %@ RSSI: %@", peripheral.name, RSSI);
        return;
    }
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    if (RSSI.integerValue < -70) {
        NSLog(@"ignore peripheral %@ RSSI: %@", peripheral.name, RSSI);
        return;
    }
    
    NSLog(@"Discovered %@ RSSI: %@ data: %@", peripheral.name, RSSI,advertisementData);
    
    // Ok, it's in range - have we already seen it?
    if (self.discoveredPeripheral != peripheral) {
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                                                    CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                                                    CBConnectPeripheralOptionNotifyOnNotificationKey:@YES}];
    }
}

- (void) connect{
    
    [self scan];
}
- (void) disconnect{

    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    [self.leConnectedSignal sendNext:@"CONNECTED"];
    
    // Stop scanning
    //[self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"]]];
    //[peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    
    NSLog(@"didRetrievePeripherals %@", peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    
    NSLog(@"didRetrieveConnectedPeripherals %@", peripherals);
}


/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service );
        if(service.UUID )
            //[self.services insertObject:service atIndex:[self.services count]];
            NSLog(@"Discovering characteristics for service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
        
        
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"did discover characteristics for service: %@", service);
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
        //[peripheral readValueForCharacteristic:characteristic];
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}


/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"did update value for characteristic");
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
    }
    
    NSData *data = characteristic.value;
    if(data != nil && [data length]==1){
        [_updatedValueSignal sendNext:characteristic];
        //int value = (*(int*)([data bytes]));
        //NSLog(@"value for characteristic: %@: %d kmh",characteristic.UUID,value);
    }
}

/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"did update notification state for characteristic");
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        //[_updatedValueSignal sendError:error];
        
    } else {
        NSData *data = characteristic.value;
        if(data != nil){
            //int value = (*(int*)([data bytes]));
            // NSLog(@"value for characteristic: %@: %d: kmh",characteristic.UUID,value);
            [self.updatedValueSignal sendNext:characteristic];
        }
        
    }
    
    
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    //self.discoveredPeripheral = nil;
    
    // TODO check reconnect in background
    // http://stackoverflow.com/questions/2687   ´8173/ios-how-to-reconnect-to-ble-device-in-background
    [central connectPeripheral:self.discoveredPeripheral options:nil];
    
    [self.leConnectedSignal sendNext:@"DISCONNECTE"];
    
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    NSLog(@"cleanup");
    
}



@end


