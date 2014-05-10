//
//  CustomAnnotation.h
//  TeamC
//
//  Created by teruyakusumoto on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

//ピンの情報を扱うクラスです。

@interface CustomAnnotation : NSObject <MKAnnotation>
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@property (readwrite, nonatomic, strong) NSString* title;
@property (readwrite, nonatomic, strong) NSString* subtitle;
@property (readwrite, nonatomic, strong) NSString* sample;
@end
