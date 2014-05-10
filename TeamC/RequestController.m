//
//  RequestController.m
//  TeamC
//
//  Created by 海下直哉 on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "RequestController.h"
#import "TemporaryDataManager.h"
#import "CustomAnnotation.h"

@implementation RequestController

// リクエストする
-(void)RequestStart{
    tempdata = [NSMutableData new];
    NSString *urlString = [NSString stringWithFormat:@"http://oasis.mogya.com/api/v0/search?n=%f&w=%f&s=%f&e=%f",
                           [TemporaryDataManager sharedManager].meLatitude+0.01f,
                           [TemporaryDataManager sharedManager].meLongitude-0.01f,
                           [TemporaryDataManager sharedManager].meLatitude-0.01f,
                           [TemporaryDataManager sharedManager].meLongitude+0.01f];
    NSLog(@"%@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //[NSURLConnection connectionWithRequest:request delegate:self];

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *first = [dic objectForKey:@"results"];
    for (NSDictionary *second in first) {
        // 情報の格納
        [[TemporaryDataManager sharedManager].adressArray addObject:[second objectForKey:@"address"]];
        [[TemporaryDataManager sharedManager].latitudeArray addObject:[second objectForKey:@"latitude"]];
        [[TemporaryDataManager sharedManager].longitudeArray addObject:[second objectForKey:@"longitude"]];
        [[TemporaryDataManager sharedManager].titleArray addObject:[second objectForKey:@"title"]];
        [[TemporaryDataManager sharedManager].url_pc_Array addObject:[second objectForKey:@"url_pc"]];
        [[TemporaryDataManager sharedManager].tagArray addObject:[second objectForKey:@"tag"]];
    }

}

@end
