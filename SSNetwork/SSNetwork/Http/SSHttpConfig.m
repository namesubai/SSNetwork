//
//  SSHttpConfig.m
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import "SSHttpConfig.h"

@implementation SSHttpConfig
+ (instancetype)shareConfig
{
    static SSHttpConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSHttpConfig alloc] init];
    });
    return instance;
}



- (NSTimeInterval)cacheTime{
    if (_cacheTime!=0) {
        return _cacheTime;
    }
    return 0;
}

- (NSTimeInterval)timeoutInterval{
    if (_timeoutInterval!=0) {
        return _timeoutInterval;
    }
    
    return 30;
}

@end
