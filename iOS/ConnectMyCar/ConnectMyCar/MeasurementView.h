//
//  MeasurementView.h
//  ConnectMyCar
//
//  Created by Marko Seifert on 05.10.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleViewModel.h"

@interface MeasurementView : UIView{
}

@property (readonly, strong, nonatomic) VehicleViewModel* vehicleModel;

- (void)bindViewToModel:(VehicleViewModel*) model;

@end
