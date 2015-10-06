//
//  ViewController.m
//  ConnectMyCar
//
//  Created by Marko Seifert on 29.09.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vehicleModel = [[VehicleModel alloc]init];
    self.vehicleModel.speed = @"1";
    self.messurmentView.vehicleModel = self.vehicleModel;
    
    self.connect.rac_command = self.vehicleModel.connectCommand;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
