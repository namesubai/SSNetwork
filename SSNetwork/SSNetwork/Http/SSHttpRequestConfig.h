//
//  HZHttpRequestConfig.h
//  HZNetWork
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

///请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypePost,   //post
    RequestTypeGet,    //get
    RequestTypeUpLoad, //上传
};
///参数上传的类型
typedef NS_ENUM(NSInteger,RequestParamsType) {
    ///默认key-value
    RequestParamsKeyValueType,
    ///json
    RequestParamsJsonType,

};

/*
 *自定义配置属性
 */
@interface SSHttpCustomObject: NSObject

///是否自动处理错误码(网络超时,网络差等情况)
@property (nonatomic, assign) BOOL isAutoHandleError;

///是否自动处理服务器返回的数据,例如(登录失效,跳登录界面)
@property (nonatomic, assign) BOOL isAutoHandleResult;


@end


/*
 *网络请求设置
 */
@interface SSHttpRequestConfig : NSObject

 ///请求方式
@property (nonatomic, assign) RequestType requestType;

///参数上传的类型
@property (nonatomic, assign) RequestParamsType requestParamsType;

///请求的链接
@property (nonatomic, copy) NSString *requestUrl;

///请求参数
@property (nonatomic, strong) NSDictionary *paramDict;

///请求头参数
@property (nonatomic, strong) NSDictionary *headerParams;

///配置全局参数
@property (nonatomic, strong) NSDictionary *unifiedParams;

///数据请求的sessionDataTask
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

///设置请求时间，默认30秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

///带参数的请求链接
@property (nonatomic, readonly) NSString *paramUrl;

///带公共参数字典
@property (nonatomic, strong) NSDictionary *returnAllParam;

///自定义数据
@property (nonatomic, strong) SSHttpCustomObject *requestCustomObject;

///上传的文件
@property (nonatomic, strong) NSArray <NSData *> *fileDatas;

///图片名称
@property (nonatomic, strong) NSArray <NSString *> *names;

///上传格式
@property (nonatomic, strong) NSArray <NSString *> *mimeTypes;

///自定义网络数据缓存的路径
@property (nonatomic, copy) NSString *customCacheKey;

///默认网络数据缓存的路径
@property (nonatomic, copy) NSString *defaultCacheKey;

///缓存时间(秒),等于0永久缓存
@property (nonatomic, assign) NSTimeInterval cacheTime;
///是否使用缓存
@property (nonatomic, assign) BOOL useCache;


///返回拼接请求链接
- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr
                              paramDict:(NSDictionary *)paramDict;

@end








