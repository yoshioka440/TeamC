//
//  TemporaryDataManager.h
//  TeamC
//
//  Created by 海下直哉 on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemporaryDataManager : NSObject{
    //float meLatitude,meLongitude;
}
+(TemporaryDataManager *)sharedManager;
-(void)LatitudeandLongitude:(float)latitude Longitude:(float)longitude;

// GPSの情報を格納
@property (nonatomic,assign) float meLatitude,meLongitude;

// 電源カフェ情報を格納する配列群
@property (nonatomic) NSMutableArray *adressArray;
@property (nonatomic) NSMutableArray *latitudeArray;
@property (nonatomic) NSMutableArray *longitudeArray;
@property (nonatomic) NSMutableArray *titleArray;
@property (nonatomic) NSMutableArray *url_pc_Array;
@property (nonatomic) NSMutableArray *tagArray;


// 待ち合わせ相手の情報を格納
@property (nonatomic) NSString *mailAdress;
@property (nonatomic) float youLatitude,youLongitude;
@end
