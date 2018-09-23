//
//  SSHttpConfig.h
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHttpRequestConfig.h"

@interface SSHttpConfig : NSObject
+ (instancetype)shareConfig;

///服务器链接
@property (nonatomic, copy) NSString *httpServiceUrl;

///缓存时间(秒),默认-1不缓存,等于0永久缓存
@property (nonatomic, assign) NSTimeInterval cacheTime;

///设置请求时间，默认30秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

///参数上传的类型
@property (nonatomic, assign) RequestParamsType requestParamsType;

///配置全局参数
@property (nonatomic, strong) NSDictionary *(^unifiedParamsConfig)(void);

///请求头参数
@property (nonatomic, strong) NSDictionary *(^headerParamsConfig)(void);



@end
