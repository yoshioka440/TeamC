//
//  ViewController.h
//  TeamC
//
//  Created by yoshioka440 on 2014/05/08.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAnnotation.h"
#import "FlatUIKit.h"

@protocol ViewControllerDelegate <NSObject>
- (void)getHisPlace;
@end

@interface ViewController : UIViewController

@property (nonatomic, assign) id<ViewControllerDelegate> viewControllerDelegate;

@end
