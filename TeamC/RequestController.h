//
//  RequestController.h
//  TeamC
//
//  Created by 海下直哉 on 2014/05/10.
//  Copyright (c) 2014年 Unko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestController : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *tempdata;
    NSMutableArray *adressdata;
}
-(void)RequestStart;
@end
