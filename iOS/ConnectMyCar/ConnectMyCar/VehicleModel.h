//
//  VehicleModel.h
//  ConnectMyCar
//
//  Created by Marko Seifert on 07.10.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol VehicleModel <NSObject>

@property (nonatomic, strong) RACSubject* updatedValueSignal;
@property (nonatomic, strong) RACSubject* leConnectedSignal;

- (void) connect;
- (void) disconnect;

@end