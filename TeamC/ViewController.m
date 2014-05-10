//
//  ViewController.m
//  TeamC
//
//  Created by yoshioka440 on 2014/05/08.
//  Copyright (c) 2014年 Unko. All rights reserved.
//  2014/5/9 海下直哉

#import "ViewController.h"

@interface ViewController ()<MKMapViewDelegate, UITextFieldDelegate>


@end

@implementation ViewController{
    MKMapView* _mapView;
    UITextField* textField_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [_mapView.userLocation addObserver:self forKeyPath:@"Location" options:0 context:NULL];
    
    //渋谷
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(35.658517, 139.701334);
    MKCoordinateRegion shibuyaRegion = MKCoordinateRegionMakeWithDistance(center, 500.0, 500.0);
    _mapView.region = shibuyaRegion;
    
    
    
    CustomAnnotation* tt = [[CustomAnnotation alloc] init];
    tt.coordinate = CLLocationCoordinate2DMake(35.658627, 139.701444);
    tt.title = @"どっか";
    tt.subtitle = @"opening in Dec 1958";
    tt.sample = @"35.655, 139.748";
    
    CustomAnnotation* st = [[CustomAnnotation alloc] init];
    st.coordinate = CLLocationCoordinate2DMake(35.658407, 139.701224);
    st.title = @"どっかpart2";
    st.subtitle = @"opening in May 2012";
    st.sample = @"35.710, 139.810";
    
    [_mapView addAnnotations:@[tt, st]];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// マップデータをインスタンスに代入するメソッド

- (void)putMapData:(float)lat myLog:(float)log title:(NSString*)title subtitle:(NSString*)subtitle
{
    CustomAnnotation* ca = [[CustomAnnotation alloc] init];
    ca.coordinate   = (CLLocationCoordinate2DMake(lat, log));
    ca.title        = title;
    ca.subtitle     = subtitle;
    //ca.sample       = sampleLog
    
    
}

/*    
 CustomAnnotation* st = [[CustomAnnotation alloc] init];
 st.coordinate = CLLocationCoordinate2DMake(35.658407, 139.701224);
 st.title = @"どっかpart2";
 st.subtitle = @"opening in May 2012";
 st.sample = @"35.710, 139.810";
 */

@end
