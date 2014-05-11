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

@interface ViewController ()<MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController{
    MKMapView* _mapView;
    UITextField* textField_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RequestController *req = [RequestController new];
    [req RequestStart];
    NSLog(@"%lu", (unsigned long)[TemporaryDataManager sharedManager].latitudeArray.count);
    self.view.backgroundColor = [UIColor clearColor];
    
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGFloat mapViewHeight;
    if (screenSize.height == 568) {
        mapViewHeight = 518;
    } else if (screenSize.height == 480){
        mapViewHeight = 430;
    }
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, mapViewHeight)];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
    [_mapView setRegion:region animated:YES];
    [_mapView.userLocation addObserver:self forKeyPath:@"Location" options:0 context:NULL];
    [self.view addSubview:_mapView];
    
    for (int i = 0; i < [TemporaryDataManager sharedManager].titleArray.count; i++) {
        [self PinOn:[TemporaryDataManager sharedManager].titleArray[i]
        LatitudeSet:[[TemporaryDataManager sharedManager].latitudeArray[i] floatValue]
       LongitudeSet:[[TemporaryDataManager sharedManager].longitudeArray[i] floatValue]
        SubTitleSet:[TemporaryDataManager sharedManager].adressArray[i]
          SampleSet:[TemporaryDataManager sharedManager].tagArray[i]];
        //NSLog(@"%f",[[TemporaryDataManager sharedManager].latitudeArray[i] floatValue]);
        //NSLog(@"%f",[[TemporaryDataManager sharedManager].longitudeArray[i] floatValue]);
    }
    
    //[_mapView addAnnotations:annotationArray];
    
    CGFloat buttonY;
    if (screenSize.height == 568) {
        buttonY = 518;
    } else if (screenSize.height == 480){
        buttonY = 430;
    }
    
    FUIButton* button1 = [[FUIButton alloc]initWithFrame:CGRectMake(0, buttonY, 107, 50)];
    button1.buttonColor = [UIColor whiteColor];
    [[button1 layer] setBorderColor:[[UIColor asbestosColor] CGColor]];
    [[button1 layer] setBorderWidth:0.5];
    [button1 setImage:[UIImage imageNamed:@"gpsIcon.png"] forState:UIControlStateNormal];
    button1.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 3, 35);
    [button1 addTarget:self action:@selector(setGPS) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button1];
    
    FUIButton* button2 = [[FUIButton alloc]initWithFrame:CGRectMake(107, buttonY, 107, 50)];
    button2.backgroundColor = [UIColor whiteColor];
    [[button2 layer] setBorderColor:[[UIColor asbestosColor] CGColor]];
    [[button2 layer] setBorderWidth:0.5];
    [button2 setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    button2.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 3, 35);
    [button2 addTarget:self action:@selector(getHisPlace) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button2];
    
    FUIButton* button3 = [[FUIButton alloc]initWithFrame:CGRectMake(214, buttonY, 107, 50)];
    button3.backgroundColor = [UIColor whiteColor];
    [[button3 layer] setBorderColor:[[UIColor asbestosColor] CGColor]];
    [[button3 layer] setBorderWidth:0.5];
    [button3 setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    button3.imageEdgeInsets = UIEdgeInsetsMake(3, 35, 3, 35);
    [self.view addSubview:button3];
}

//現在地ボタン
- (void)setGPS
{
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    //アニメーションほしい
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    // 地図の中心座標に現在地を設定
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    [_mapView.userLocation removeObserver:self forKeyPath:@"Location"];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[HumanAnnotation class]]) {
        return nil;
    }
    static NSString* reuseId = @"ann";
    MKAnnotationView* av = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (av == nil) {
        av = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseId];
        av.canShowCallout = YES;
        av.image = [UIImage imageNamed:@"human.png"];
    } else {
        av.annotation = annotation;
    }
    UIButton* detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    av.rightCalloutAccessoryView = detailButton;
    return av;
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

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [TemporaryDataManager sharedManager].meLatitude = newLocation.coordinate.latitude;
    [TemporaryDataManager sharedManager].meLongitude = newLocation.coordinate.longitude;
    //NSLog(@"%f",[TemporaryDataManager sharedManager].meLongitude);
}

//ピンを立てる
-(void)PinOn:(NSString *)title LatitudeSet:(float)latitude LongitudeSet:(float)longitude SubTitleSet:(NSString *)subTitle SampleSet:(NSString *)sample{
    CustomAnnotation* tt = [[CustomAnnotation alloc] init];
    tt.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    tt.title = title;
    tt.subtitle = subTitle;
    tt.sample = sample;
    [_mapView addAnnotation:tt];
}

//相手の位置を表示する
-(void)showHisPlaceAnnotation:(NSString *)title LatitudeSet:(float)latitude LongitudeSet:(float)longitude{
    HumanAnnotation* humanAnnotation = [[HumanAnnotation alloc] init];
    humanAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    humanAnnotation.title = @"楠本輝也";
    [_mapView addAnnotation:humanAnnotation];
}

// リクエストする
-(void)getHisPlace
{
    tempdata = [NSMutableData new];
    NSString *urlString = [NSString stringWithFormat:@"http://10.13.37.248:8888/index.php"];
    NSLog(@"%@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //[NSURLConnection connectionWithRequest:request delegate:self];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *hisInfo in dic) {
        // 情報の格納
        [TemporaryDataManager sharedManager].mailAdress = [NSString stringWithFormat:@"%@",[hisInfo objectForKey:@"mail"]];
        [TemporaryDataManager sharedManager].youLatitude = [[hisInfo objectForKey:@"latitude"]floatValue];
        [TemporaryDataManager sharedManager].youLongitude = [[hisInfo objectForKey:@"longitude"]floatValue];
        
        NSLog(@"相手の緯度は%f", [TemporaryDataManager sharedManager].youLatitude);
        
        [self showHisPlaceAnnotation:[TemporaryDataManager sharedManager].mailAdress
                         LatitudeSet:[TemporaryDataManager sharedManager].youLatitude
                        LongitudeSet:[TemporaryDataManager sharedManager].youLongitude];
    }
    _mapView.centerCoordinate = CLLocationCoordinate2DMake([TemporaryDataManager sharedManager].youLatitude
, [TemporaryDataManager sharedManager].youLongitude);
}

// 自分の現在地を送る(テスト段階では使わない？)
-(void)sendMyPlace{
    tempdata = [NSMutableData new];
    NSString *urlString = [NSString stringWithFormat:@"http://10.13.37.248:8888/insert.php?mail=%@&latitude=%f&longitude=%f",
                           @"teruyakusumoto@gmail.com",
                           [TemporaryDataManager sharedManager].meLatitude,
                           [TemporaryDataManager sharedManager].meLongitude];
    NSLog(@"%@",urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
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
