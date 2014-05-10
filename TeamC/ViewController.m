//
//  ViewController.m
//  TeamC
//
//  Created by yoshioka440 on 2014/05/08.
//  Copyright (c) 2014年 Unko. All rights reserved.
//  2014/5/9 海下直哉

#import "ViewController.h"
#import "RequestController.h"
#import "TemporaryDataManager.h"
#import "HumanAnnotation.h"

@interface ViewController ()<MKMapViewDelegate, UITextFieldDelegate>


@end

@implementation ViewController{
    MKMapView* _mapView;
    UITextField* textField_;
    
    CLLocationManager *cl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    RequestController *req = [RequestController new];
    [req RequestStart];
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [_mapView.userLocation addObserver:self forKeyPath:@"Location" options:0 context:NULL];
    [TemporaryDataManager sharedManager].meLatitude = _mapView.userLocation.location.coordinate.latitude;
    [TemporaryDataManager sharedManager].meLongitude = _mapView.userLocation.location.coordinate.longitude;
    
    for (int i = 0; i < [TemporaryDataManager sharedManager].titleArray.count; i++) {
        [self PinOn:[TemporaryDataManager sharedManager].titleArray[i]
         LatitudeSet:[[TemporaryDataManager sharedManager].latitudeArray[i] floatValue]
        LongitudeSet:[[TemporaryDataManager sharedManager].longitudeArray[i] floatValue]
        SubTitleSet:[TemporaryDataManager sharedManager].adressArray[i]
          SampleSet:[TemporaryDataManager sharedManager].tagArray[i]];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(50, 500, 220, 50);
    [button setTitle:@"LINE で送る" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(sendToLineButtonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITextField *textField = [[UITextField alloc]
                              initWithFrame:CGRectMake(50, 450, 220, 40)];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:textField];
    textField.delegate = self;
    textField_ = textField;
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    // 地図の中心座標に現在地を設定
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    
    // 表示倍率の設定
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
    [_mapView setRegion:region animated:YES];
}


////LINEで送る機能

- (void)sendToLineButtonWasTapped:(id)sender {
    NSString *plainString = textField_.text;
    
    // escape
    NSString *contentKey = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                        NULL,
                                                                                        (CFStringRef)plainString,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                        kCFStringEncodingUTF8 );
    
    NSString *contentType = @"text";
    
    // LINE のサイトに遷移して、アプリが入っている場合はラインにリダイレクトする方法。
    NSString *urlString = [NSString
                           stringWithFormat: @"http://line.naver.jp/R/msg/%@/?%@",
                           contentType, contentKey];
    NSURL *url = [NSURL URLWithString:urlString];
    /*
     // LINE に直接遷移。contentType で画像を指定する事もできる。アプリが入っていない場合は何も起きない。
     NSString *urlString2 = [NSString
     stringWithFormat:@"line://msg/%@/%@",
     contentType, contentKey];
     NSURL *url = [NSURL URLWithString:urlString2];
     */
    
    [[UIApplication sharedApplication] openURL:url];
}

-(void)PinOn:(NSString *)title LatitudeSet:(float)latitude LongitudeSet:(float)longitude SubTitleSet:(NSString *)subTitle SampleSet:(NSString *)sample{
    CustomAnnotation* tt = [[CustomAnnotation alloc] init];
    tt.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    tt.title = title;
    tt.subtitle = subTitle;
    tt.sample = sample;
    [_mapView addAnnotations:@[tt]];
}


//相手の位置を表示する

- (void)showHisPlaceAnnotation
{
    HumanAnnotation* human = [[HumanAnnotation alloc]init];
    human.coordinate = CLLocationCoordinate2DMake([TemporaryDataManager sharedManager].youLatitude, [TemporaryDataManager sharedManager].youLongitude);
//    human.image = [UIImage imageNamed:@"human1.png"]; //人のアイコン画像どうやって設定しよう
    [_mapView addAnnotation:human];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
