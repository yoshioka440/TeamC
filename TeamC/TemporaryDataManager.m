//
//  TemporaryDataManager.m
//  TeamC
//
//  Created by 海下直哉 on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import "TemporaryDataManager.h"

@implementation TemporaryDataManager
static TemporaryDataManager *temporaryDataManager_ = nil;

+(TemporaryDataManager *)sharedManager{
    @synchronized(self){
        if (!temporaryDataManager_) {
            temporaryDataManager_ = [TemporaryDataManager new];
        }
    }
    
    return temporaryDataManager_;
}

-(id)init{
    self = [super init];
    if (self) {
        // 初期化
        //_meLatitude = 0;
        //_meLongitude = 0;
        _adressArray = [NSMutableArray new];
        _latitudeArray = [NSMutableArray new];
        _longitudeArray = [NSMutableArray new];
        _titleArray = [NSMutableArray new];
        _url_pc_Array = [NSMutableArray new];
        _tagArray = [NSMutableArray new];
    }
    
    return self;
}

@end
