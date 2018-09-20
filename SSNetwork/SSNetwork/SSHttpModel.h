//
//  SSHttpModel.h
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNetwork.h"

typedef void (^ResponseHandler)(id dataObj,NSError *error,BOOL isCache);
typedef void (^RequestConfigHandle)(SSHttpRequestConfig *requestConfig);

@protocol SSHttpModelDelegate<NSObject>

@optional

///init初始化时调用,子类重写
- (void)ss_init;

///返回要替换的字段字典
- (NSDictionary *)ss_replacedKeyFromPropertyName;

///返回对应的数组字段
- (NSDictionary *)ss_setupObjectClassInArray;


@end

@interface SSHttpModel : NSObject<SSHttpModelDelegate>


///get请求

+ (void)getRequestWithUrlStr:(NSString *)urlStr
                   paramDict:(id)paramDict
               responseBlock:(ResponseHandler)responseBlock;


///get请求可配置requestConfig
+ (void)getRequestWithUrlStr:(NSString *)urlStr
                   paramDict:(id)paramDict
         requestConfigHandle:(RequestConfigHandle)requestConfigHandle
               responseBlock:(ResponseHandler)responseBlock;




///post请求
+ (void)postRequestWithUrlStr:(NSString *)urlStr
                    paramDict:(id)paramDict
                responseBlock:(ResponseHandler)responseBlock;

///post请求可配置requestConfig
+ (void)postRequestWithUrlStr:(NSString *)urlStr
                    paramDict:(id)paramDict
          requestConfigHandle:(RequestConfigHandle)requestConfigHandle
                responseBlock:(ResponseHandler)responseBlock;



///upload
+ (void)uploadRequestWithUrlStr:(NSString *)urlStr
                      paramDict:(id)paramDict
                  responseBlock:(ResponseHandler)responseBlock
                 uploadProgress:(LoadProgress)progress;



///网络请求可配置requesConfig
+ (void)requestWithRequestConfigHandle:(RequestConfigHandle)requestConfigHandle
                         responseBlock:(ResponseHandler)responseBlock;

///上传文件可配置requesConfig
+ (void)uploadWithRequestConfigHandle:(RequestConfigHandle)requestConfigHandle
                        responseBlock:(ResponseHandler)responseBlock
                       uploadProgress:(LoadProgress)progress;

///网络请求
+ (void)requestWithRequestConfig:(SSHttpRequestConfig *)requestConfig
                   responseBlock:(ResponseHandler)responseBlock;

///上传文件
+ (void)uploadWithRequestConfig:(SSHttpRequestConfig *)requestConfig
                  responseBlock:(ResponseHandler)responseBlock
                 uploadProgress:(LoadProgress)progress;
@end
