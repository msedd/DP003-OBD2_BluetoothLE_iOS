//
//  ViewController.m
//  ConnectMyCar
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "MessurementViewController.h"
#import "BLEController.h"

@interface MessurementViewController ()

@end

@implementation MessurementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vehicleViewModel = [[VehicleViewModel alloc]initWithModel:[BLEController sharedController]];
    self.vehicleViewModel.speed = @"";
    [self.messurmentView bindViewToModel:self.vehicleViewModel];
    self.connect.rac_command = self.vehicleViewModel.connectCommand;
    
    
    [self.messurmentView setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
