//
//  VehicleData.m
//  OBD LE
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "VehicleModel.h"
#import <Crashlytics/Crashlytics.h>

@implementation VehicleModel

- (id)init{
    
    self.leController = [BLEController sharedController];
    [self _initCommands];
    
    [self.leController.updatedValueSignal subscribeNext:^(CBCharacteristic* characteristic) {
        NSData *data = characteristic.value;
        int value = (*(int*)([data bytes]));
        NSString *speed = [NSString stringWithFormat:@"%d", value];
        self.speed = speed;
        NSLog(@"Speed: %d: km/h",value);
    }];
    
    [self.leController.leConnectedSignal subscribeNext:^(NSString* state) {
        if ([state isEqualToString:@"CONNECTED"] ) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }else{
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        
    }];
    return  self;
}

- (void) _initCommands{
    self.connectCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        [self.leController connect];
        return [RACSignal empty];
    }];
    
    self.disconnectCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        
        [self.leController disconnect];
        return [RACSignal empty];
    }];
}

@end
