//
//  VehicleDate.h
//  OBD LE
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BLEController.h"

@interface VehicleModel : NSObject {
    
}
@property (strong, nonatomic) NSString *speed;
@property BOOL enable;
@property (strong, nonatomic) NSString *state;
@property BLEController* leController;
@property RACCommand* connectCommand;
@property RACCommand* disconnectCommand;

@end