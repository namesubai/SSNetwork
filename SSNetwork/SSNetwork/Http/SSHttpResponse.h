//
//  SSHttpResponse.h
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSHttpRequestConfig;

typedef NS_ENUM(NSInteger, SSHttpResponseStatus) {
    HttpResponseSuccess  =  -1,//请求成功
};

@interface SSHttpResponse : NSObject
///返回错误
@property (nonatomic, strong) NSError *responseError;
///返回数据
@property (nonatomic, strong) id responseResult;
///是否缓存数据
@property (nonatomic, assign) BOOL isCacheData;

///统一处理错误
+ (void)handelResult:(id)result
               error:(NSError *)error
       requestConfig:(SSHttpRequestConfig *)requestConfig;

@end
