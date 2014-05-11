//
//  HumanPlaceRequestController.h
//  TeamC
//
//  Created by teruyakusumoto on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "HumanAnnotation.h"

@interface HumanPlaceRequestController : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *tempdata;
    NSMutableArray *adressdata;
}

-(void)getHisPlace;
-(void)sendMyPlace;

@end
