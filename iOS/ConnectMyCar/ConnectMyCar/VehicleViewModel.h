//
//  VehicleDate.h
//  OBD LE
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "VehicleModel.h"

@interface VehicleViewModel : NSObject {
    
    
}

- (id)initWithModel:(id <VehicleModel>)vehicleModel;
@property (strong, nonatomic) NSString *speed;
@property BOOL connected;
@property (strong, nonatomic) NSString *state;
@property id <VehicleModel> vehicleModel;
@property RACCommand* connectCommand;
@property RACCommand* disconnectCommand;

@end