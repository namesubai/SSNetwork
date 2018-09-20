//
//  SSCacheDataCenter.m
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import "SSCacheDataCenter.h"
#import "SSCacheBaseData.h"
#import <CommonCrypto/CommonDigest.h>

#define HttpAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif
static NSString *const kHttpCacheFileName    = @"RequestCache";


static dispatch_queue_t cache_writing_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.ss.caching", attr);
    });
    
    return queue;
}


@implementation SSCacheDataCenter
+ (instancetype)sharedCenter
{
    static SSCacheDataCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSCacheDataCenter alloc] init];
    });
    return instance;
}

- (void)saveHttpCacheData:(NSData *)cacheData cachePath:(NSString *)cachePath cacheTime:(NSTimeInterval)cacheTime{
    
    NSString *path = [self returnHttpFilePath];
    NSString *cache = [self returnCachePath:cachePath];
    dispatch_async(cache_writing_queue(), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                                       attributes:nil error:&error];
            if (error) {
                NSLog(@"创建网络缓存文件夹失败");
            }
        }
        
        
        BOOL isSuceess = [cacheData writeToFile:cache atomically:YES];
        if (isSuceess) {
            
            NSLog(@"网络缓存成功,路径:\n%@",[path stringByAppendingPathComponent:cache]);
        }
        SSCacheBaseData *basicData = [SSCacheBaseData new];
        basicData.appVerSionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if (cacheTime > 0) {
            @autoreleasepool {
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:cacheTime];
                basicData.expirationTime =[NSString stringWithFormat:@"%f",date.timeIntervalSinceNow];
            }
           
        }
        [NSKeyedArchiver archiveRootObject:basicData toFile:[self returnCacheBasicDataFilePathWithCachePath:cachePath]];
        
    });
    
}

- (void)getHttpCacheDataFromCachePath:(NSString *)cachePath success:(void(^)(NSData *cacheData))success{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[self returnCachePath:cachePath] isDirectory:nil]) {
        //读取基本缓存信息
        SSCacheBaseData *basicData = [self loadBaseCachePath:cachePath];
        if (![basicData.appVerSionString isEqualToString:HttpAppVersion]) {
            NSLog(@"版本号不匹配");
        }else{
            if (basicData.expirationTime) {
                @autoreleasepool {
                    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:basicData.expirationTime.doubleValue];
                    
                    if ([tempDate compare:[NSDate date]] == NSOrderedAscending) {
                        ///过期移除
                        [self removeCachesWithcachePath:cachePath];
                    }
                }
                
            }else{
                //读取缓存
                dispatch_async(cache_writing_queue(), ^{
                    NSData *cacheData = [NSData dataWithContentsOfFile:[self returnCachePath:cachePath]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(cacheData);
                        }
                    });
                });
            }
           
           
        }
        
    }
    
}



#pragma mark - 返回文件夹路径
- (NSString *)returnHttpFilePath{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:kHttpCacheFileName];
    return path;
}

#pragma mark - 返回缓存的路径
- (NSString *)returnCachePath:(NSString *)cacheKey{
    return [[self returnHttpFilePath] stringByAppendingPathComponent:[self md5StringFromString:cacheKey]];
}

#pragma mark - md5编码
- (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}
#pragma mark - 缓存的配置信息的路径
- (NSString *)returnCacheBasicDataFilePathWithCachePath:(NSString *)cacheKey {
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.basicData", [self returnCachePath:cacheKey]];
    return cacheMetadataFileName;
}
#pragma mark - 读取缓存配置信息
- (SSCacheBaseData *)loadBaseCachePath:(NSString *)cachePath{
    NSString *path = [self returnCacheBasicDataFilePathWithCachePath:cachePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    SSCacheBaseData *basicData = nil;
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        @try {
            basicData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        } @catch (NSException *exception) {
            NSLog(@"读取缓存配置信息失败%@", exception.reason);
        }
    }
    return basicData;
}

- (void)removeCachesWithcachePath:(NSString *)cachePath {
    NSString *path = [self returnCacheBasicDataFilePathWithCachePath:cachePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

- (void)removeAllCaches{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *filepath = [self returnHttpFilePath];
    if ([fileManager fileExistsAtPath:filepath isDirectory:nil]) {
        [fileManager removeItemAtPath:filepath error:nil];
    }

}

- (void)calculateCacheSizeFinish:(void(^)(double size))size{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString *filepath = [self returnHttpFilePath];
    if (![manager fileExistsAtPath:filepath]){
       !size?:size(0);
    }else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:filepath] objectEnumerator];
            NSString* fileName;
            long long folderSize = 0;
            while ((fileName = [childFilesEnumerator nextObject]) != nil){
                NSString* fileAbsolutePath = [filepath stringByAppendingPathComponent:fileName];
                folderSize += [self fileSizeAtPath:fileAbsolutePath];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                !size?:size(folderSize/(1024.0*1024.0));
            });
        });
       
    }
    
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
