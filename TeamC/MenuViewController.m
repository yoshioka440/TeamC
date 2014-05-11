//
//  MenuViewController.m
//  TeamC
//
//  Created by 海下直哉 on 2014/05/11.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "MenuViewController.h"
#import "TemporaryDataManager.h"
#import "FlatUIKit.h"

@interface MenuViewController (){
    CLLocationManager *lm;
}

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView* backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"40.jpg"]];
    [self.view addSubview:backImg];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 150)];
    label.text = @"電源カフェでミーティング";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:36];
    [self.view addSubview:label];
    
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
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGFloat buttonY;
    if (screenSize.height == 568) {
        buttonY = 430;
    } else if (screenSize.height == 480){
        buttonY = 380;
    }
    FUIButton *button = [[FUIButton alloc]initWithFrame:CGRectMake(0, buttonY, 320, 50)];
    button.backgroundColor = [UIColor turquoiseColor];
    [button setTitle:@"Start" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
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
