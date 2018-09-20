//
//  SSHttpModel.m
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import "SSHttpModel.h"
#import "MJExtension.h"

@implementation SSHttpModel
- (id)init{
    self = [super init];
    
    if (self) {
        
        if ([self respondsToSelector:@selector(ss_replacedKeyFromPropertyName)]) {
            [self.class mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return [self ss_replacedKeyFromPropertyName];
            }];
        }
        
        if ([self respondsToSelector:@selector(ss_setupObjectClassInArray)]) {
            [self.class mj_setupObjectClassInArray:^NSDictionary *{
                return [self ss_setupObjectClassInArray];
            }];
        }
        
        if ([self respondsToSelector:@selector(ss_init)]) {
            [self ss_init];
        }
        
    }
    
    return self;
}
#pragma mark - 网络请求方法

+ (void)getRequestWithUrlStr:(NSString *)urlStr
                   paramDict:(id)paramDict
               responseBlock:(ResponseHandler)responseBlock{
    [self requestWithRequestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.requestType = RequestTypeGet;
        requestConfig.requestUrl = urlStr;
        requestConfig.paramDict = paramDict;
    } responseBlock:responseBlock];
}



+ (void)getRequestWithUrlStr:(NSString *)urlStr
                   paramDict:(id)paramDict
         requestConfigHandle:(RequestConfigHandle)requestConfigHandle
               responseBlock:(ResponseHandler)responseBlock{
    [self requestWithRequestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.requestType = RequestTypeGet;
        requestConfig.requestUrl = urlStr;
        requestConfig.paramDict = paramDict;
        !requestConfigHandle?:requestConfigHandle(requestConfig);
    } responseBlock:responseBlock];
}



+ (void)postRequestWithUrlStr:(NSString *)urlStr
                    paramDict:(id)paramDict
                responseBlock:(ResponseHandler)responseBlock{
    [self requestWithRequestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.requestType = RequestTypePost;
        requestConfig.requestUrl = urlStr;
        requestConfig.paramDict = paramDict;
    } responseBlock:responseBlock];
}

+ (void)postRequestWithUrlStr:(NSString *)urlStr
                    paramDict:(id)paramDict
          requestConfigHandle:(RequestConfigHandle)requestConfigHandle
                responseBlock:(ResponseHandler)responseBlock{
    [self requestWithRequestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.requestType = RequestTypePost;
        requestConfig.requestUrl = urlStr;
        requestConfig.paramDict = paramDict;
        !requestConfigHandle?:requestConfigHandle(requestConfig);
    } responseBlock:responseBlock];
}



+ (void)uploadRequestWithUrlStr:(NSString *)urlStr
                      paramDict:(id)paramDict
                  responseBlock:(ResponseHandler)responseBlock
                 uploadProgress:(LoadProgress)progress{
    [self uploadWithRequestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.requestType = RequestTypeUpLoad;
        requestConfig.requestUrl = urlStr;
        requestConfig.paramDict = paramDict;
    } responseBlock:responseBlock uploadProgress:progress];
}



+ (void)requestWithRequestConfigHandle:(RequestConfigHandle)requestConfigHandle
                         responseBlock:(ResponseHandler)responseBlock{
    SSHttpRequestConfig *requestConfig = [SSHttpRequestConfig new];
    !requestConfigHandle?:requestConfigHandle(requestConfig);
    [self requestWithRequestConfig:requestConfig responseBlock:responseBlock];
    
}

+ (void)uploadWithRequestConfigHandle:(RequestConfigHandle)requestConfigHandle
                        responseBlock:(ResponseHandler)responseBlock
                       uploadProgress:(LoadProgress)progress{
    SSHttpRequestConfig *requestConfig = [SSHttpRequestConfig new];
    !requestConfigHandle?:requestConfigHandle(requestConfig);
    [self uploadWithRequestConfig:requestConfig responseBlock:responseBlock uploadProgress:progress];
}


+ (void)requestWithRequestConfig:(SSHttpRequestConfig *)requestConfig
                   responseBlock:(ResponseHandler)responseBlock {
    [[SSHttpRequest shareRequest]requestWithConfig:requestConfig responseResult:^(SSHttpResponse *response, SSHttpRequestConfig *requestConfig) {
        if (response.responseResult) {
            id data = [self mj_objectWithKeyValues:response.responseResult];
            !responseBlock?:responseBlock(data,nil,response.isCacheData);
        }else{
            !responseBlock?:responseBlock(nil,response.responseError,response.isCacheData);
        }
    }];
}

+ (void)uploadWithRequestConfig:(SSHttpRequestConfig *)requestConfig
                  responseBlock:(ResponseHandler)responseBlock
                 uploadProgress:(LoadProgress)progress{
    [[SSHttpRequest shareRequest]upLoadWithConfig:requestConfig responseResult:^(SSHttpResponse *response, SSHttpRequestConfig *requestConfig) {
        if (response.responseResult) {
            id data = [self mj_objectWithKeyValues:response.responseResult];
            !responseBlock?:responseBlock(data,nil,response.isCacheData);
        }else{
            !responseBlock?:responseBlock(nil,response.responseError,response.isCacheData);
        }
    } progress:progress];
}

@end
