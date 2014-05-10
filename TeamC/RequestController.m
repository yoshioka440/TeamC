//
//  RequestController.m
//  TeamC
//
//  Created by 海下直哉 on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "RequestController.h"
#import "TemporaryDataManager.h"

@implementation RequestController

// リクエストする
-(void)RequestStart{
    tempdata = [NSMutableData new];

    NSURL *url = [[NSURL alloc] initWithString:@"http://oasis.mogya.com/api/v0/search?n=34.70849&w=135.48775&s=34.69727&e=135.50951"];
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
    
    // NSStringでないと、文字が正常に表示出来ない。(テストコード)
    NSString *str = [TemporaryDataManager sharedManager].tagArray[0];
    NSLog(@"%@",str);
}

@end
