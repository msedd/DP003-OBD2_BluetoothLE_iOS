//
//  ViewController.m
//  ConnectMyCar
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "MessurementViewController.h"

@interface MessurementViewController ()

@end

@implementation MessurementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vehicleModel = [[VehicleViewModel alloc]init];
    self.vehicleModel.speed = @"1";
    self.messurmentView.vehicleModel = self.vehicleModel;
    
    self.connect.rac_command = self.vehicleModel.connectCommand;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
