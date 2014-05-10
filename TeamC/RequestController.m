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

/*// 通信開始時
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
    //NSString *str = [TemporaryDataManager sharedManager].titleArray[0];
    float lat = [[TemporaryDataManager sharedManager].latitudeArray[0] floatValue];
    NSLog(@"%f",lat);
    
    
    for (int i = 0; i < [TemporaryDataManager sharedManager].titleArray.count; i++) {
        [self PinOn:[TemporaryDataManager sharedManager].titleArray[i]
        LatitudeSet:[[TemporaryDataManager sharedManager].latitudeArray[i] floatValue]
       LongitudeSet:[[TemporaryDataManager sharedManager].longitudeArray[i] floatValue]
        SubTitleSet:[TemporaryDataManager sharedManager].adressArray[i]
          SampleSet:[TemporaryDataManager sharedManager].tagArray[i]];
        NSLog(@"%f",[[TemporaryDataManager sharedManager].latitudeArray[i] floatValue]);
        NSLog(@"%f",[[TemporaryDataManager sharedManager].longitudeArray[i] floatValue]);
    }

}

-(void)PinOn:(NSString *)title LatitudeSet:(float)latitude LongitudeSet:(float)longitude SubTitleSet:(NSString *)subTitle SampleSet:(NSString *)sample{
    CustomAnnotation* tt = [[CustomAnnotation alloc] init];
    tt.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    tt.title = title;
    tt.subtitle = subTitle;
    tt.sample = sample;
    [[TemporaryDataManager sharedManager].annotationArray addObject:tt];
}
*/
@end
