//
//  BLEController.h
//  BluetoothLE_Tester
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "VehicleModel.h"

@interface BLEController : NSObject <CBPeripheralDelegate, CBCentralManagerDelegate, VehicleModel>{

}
@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;
@property (nonatomic, strong) RACSubject* updatedValueSignal;
@property (nonatomic, strong) RACSubject* leConnectedSignal;

+ (BLEController *)sharedController;

@end
