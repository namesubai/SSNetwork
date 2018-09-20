//
//  SSCacheDataCenter.h
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSCacheBaseData;

@interface SSCacheDataCenter : NSObject
+ (instancetype)sharedCenter;

///保存缓存到指定的路径
- (void)saveHttpCacheData:(NSData *)cacheData  cachePath:(NSString *)cachePath cacheTime:(NSTimeInterval)cacheTime;

///读取缓存
- (void)getHttpCacheDataFromCachePath:(NSString *)cachePath success:(void(^)(NSData *cacheData))success;

///读取基本配置缓存
- (SSCacheBaseData *)loadBaseCachePath:(NSString *)cachePath;

///移除某个缓存
- (void)removeCachesWithcachePath:(NSString *)cachePath;

///删除所有缓存
- (void)removeAllCaches;

///计算总缓存大小(单位M)
- (void)calculateCacheSizeFinish:(void(^)(double size))size;



@end
