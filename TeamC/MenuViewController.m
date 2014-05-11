//
//  MenuViewController.m
//  TeamC
//
//  Created by 海下直哉 on 2014/05/11.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "MenuViewController.h"
#import "TemporaryDataManager.h"

@interface MenuViewController (){
    CLLocationManager *lm;
}

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lm = [CLLocationManager new];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    [lm startUpdatingLocation];
    [self NowPlaceButton];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [TemporaryDataManager sharedManager].meLatitude = newLocation.coordinate.latitude;
    [TemporaryDataManager sharedManager].meLongitude = newLocation.coordinate.longitude;
    //NSLog(@"%f",[TemporaryDataManager sharedManager].meLongitude);
}

-(void)NowPlaceButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, 100, 100);
    [button setTitle:@"Start" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)ButtonTapped:(UIButton *)button{
    [self performSegueWithIdentifier:@"map" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
