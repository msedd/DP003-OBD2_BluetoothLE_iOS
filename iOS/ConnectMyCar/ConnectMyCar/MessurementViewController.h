//
//  ViewController.h
//  ConnectMyCar
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasurementView.h"
#import "VehicleViewModel.h"

@interface MessurementViewController : UIViewController

@property (strong, nonatomic) IBOutlet MeasurementView *messurmentView;
@property (strong, nonatomic) VehicleViewModel* vehicleViewModel;
@property (strong, nonatomic) IBOutlet UIButton *connect;

@end

