//
//  ViewController.m
//  TeamC
//
//  Created by yoshioka440 on 2014/05/08.
//  Copyright (c) 2014年 Unko. All rights reserved.
//  2014/5/9 海下直哉 a

#import "ViewController.h"
#import "RequestController.h"
#import "TemporaryDataManager.h"
#import "HumanAnnotation.h"
#import "FlatUIKit.h"

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
    button1.imageEdgeInsets = UIEdgeInsetsMake(3, 30, 3, 30);
    [self.view addSubview:button1];
    FUIButton* button2 = [[FUIButton alloc]initWithFrame:CGRectMake(107, buttonY, 107, 50)];
    button2.backgroundColor = [UIColor whiteColor];
    [[button2 layer] setBorderColor:[[UIColor asbestosColor] CGColor]];
    [[button2 layer] setBorderWidth:0.5];
    [button2 setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    button2.imageEdgeInsets = UIEdgeInsetsMake(3, 30, 3, 30);
    [self.view addSubview:button2];
    FUIButton* button3 = [[FUIButton alloc]initWithFrame:CGRectMake(214, buttonY, 107, 50)];
    button3.backgroundColor = [UIColor whiteColor];
    [[button3 layer] setBorderColor:[[UIColor asbestosColor] CGColor]];
    [[button3 layer] setBorderWidth:0.5];
    [button3 setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    button3.imageEdgeInsets = UIEdgeInsetsMake(3, 30, 3, 30);
    [self.view addSubview:button3];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    // 地図の中心座標に現在地を設定
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    [_mapView.userLocation removeObserver:self forKeyPath:@"Location"];
}

/*-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView;
    NSString *identifier = @"Pin";
    annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.annotation = annotation;
    return annotationView;
}*/

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // add detail disclosure button to callout
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        ((MKAnnotationView*)obj).rightCalloutAccessoryView
        = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *detailView = [UIView new];
    detailView.frame = CGRectMake(0, screenRect.size.height-100, screenRect.size.width, 100);
    detailView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:detailView];
    
    
    UILabel *title = [UILabel new];
    title.frame = CGRectMake(detailView.frame.origin.x, detailView.frame.origin.y, detailView.frame.size.width, 50);
    title.text = view.annotation.title;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:title];
    
    UILabel *subtitle = [UILabel new];
    subtitle.frame = CGRectMake(detailView.frame.origin.x, detailView.frame.origin.y+20, detailView.frame.size.width, 50);
    subtitle.text = view.annotation.subtitle;
    subtitle.textColor = [UIColor whiteColor];
    subtitle.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:subtitle];
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

// カフェのピンを立てる
-(void)PinOn:(NSString *)title LatitudeSet:(float)latitude LongitudeSet:(float)longitude SubTitleSet:(NSString *)subTitle SampleSet:(NSString *)sample{
    CustomAnnotation* tt = [[CustomAnnotation alloc] init];
    tt.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    tt.title = title;
    tt.subtitle = subTitle;
    tt.sample = sample;
    [_mapView addAnnotation:tt];
}

//相手の位置を表示する
- (void)showHisPlaceAnnotation
{
    HumanAnnotation* human = [[HumanAnnotation alloc]init];
    human.coordinate = CLLocationCoordinate2DMake([TemporaryDataManager sharedManager].youLatitude, [TemporaryDataManager sharedManager].youLongitude);
//    human.image = [UIImage imageNamed:@"human.png"]; //人のアイコン画像どうやって設定しよう
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
