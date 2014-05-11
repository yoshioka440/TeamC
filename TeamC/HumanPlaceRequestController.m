//
//  HumanPlaceRequestController.m
//  TeamC
//
//  Created by teruyakusumoto on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "HumanPlaceRequestController.h"
#import "TemporaryDataManager.h"
#import "HumanAnnotation.h"

@interface HumanPlaceRequestController()<ViewControllerDelegate>

@property(nonatomic, strong) ViewController* viewController;

@end

@implementation HumanPlaceRequestController

- (id)init
{
    self.viewController = [[ViewController alloc]init];
    self.viewController.viewControllerDelegate = self;
    return self;
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
        
        NSLog(@"相手の緯度は%f", [TemporaryDataManager sharedManager].youLatitude);    }
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

@end
