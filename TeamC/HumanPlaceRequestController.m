//
//  HumanPlaceRequestController.m
//  TeamC
//
//  Created by teruyakusumoto on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "HumanPlaceRequestController.h"
#import "TemporaryDataManager.h"

@implementation HumanPlaceRequestController

// リクエストする
-(void)getHisPlace{
    tempdata = [NSMutableData new];
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:8888/index.php"];
    NSLog(@"%@",urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// 自分の現在地を送る
-(void)sendMyPlace{
    tempdata = [NSMutableData new];
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:8888/insert.php?mail=%@&latitude=%f&longitude=%f",
                           @"teruyakusumoto@gmail.com",
                           [TemporaryDataManager sharedManager].meLatitude,
                           [TemporaryDataManager sharedManager].meLongitude];
    NSLog(@"%@",urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// 通信開始時
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [tempdata appendData:data];
}

// 通信失敗時
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"失敗");
}

// 通信終了時
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"成功");
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:tempdata options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *hisInfo in dic) {
        // 情報の格納
        [TemporaryDataManager sharedManager].mailAdress = [NSString stringWithFormat:@"%@",[hisInfo objectForKey:@"mail"]];
        [TemporaryDataManager sharedManager].youLatitude = [[hisInfo objectForKey:@"latitude"]floatValue];
        [TemporaryDataManager sharedManager].youLongitude = [[hisInfo objectForKey:@"longitude"]floatValue];
    }
    
    // NSStringでないと、文字が正常に表示出来ない。(テストコード)
    /*NSString *str = [TemporaryDataManager sharedManager].tagArray[0];
     NSLog(@"%@",str);
     */
}

@end
