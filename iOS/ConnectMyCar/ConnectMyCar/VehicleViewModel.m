//
//  VehicleData.m
//  OBD LE
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "VehicleViewModel.h"
#import <Crashlytics/Crashlytics.h>

@implementation VehicleViewModel

- (id)initWithModel:(id <VehicleModel>)vehicleModel{
    
    self.vehicleModel = vehicleModel;
    [self _initCommands];
    
    [self.vehicleModel.updatedValueSignal subscribeNext:^(NSNumber* speed) {
        
        if ([speed integerValue]==50) {
        
            [Answers logCustomEventWithName:@"SPEED LIMIT"
                           customAttributes:@{
                                              @"Driver" : @"MSE",
                                              @"Speed" : speed}];
         
        }
        self.speed = [speed stringValue];
        NSLog(@"Speed: %@: km/h",[speed stringValue]);
    }];
    
    [self.vehicleModel.leConnectedSignal subscribeNext:^(NSString* state) {
        if ([state isEqualToString:@"CONNECTED"] ) {
            [Answers logCustomEventWithName:@"BTLE CONNECTED"
                           customAttributes:@{}];
            self.connected = true;
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }else{
            [Answers logCustomEventWithName:@"BTLE DISCONNECTED"
                           customAttributes:@{}];
            self.connected = false;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        
    }];
    return  self;
}

- (void) _initCommands{
    self.connectCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        [self.vehicleModel connect];
        return [RACSignal empty];
    }];
    
    self.disconnectCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        
        [self.vehicleModel disconnect];
        return [RACSignal empty];
    }];
}

@end
