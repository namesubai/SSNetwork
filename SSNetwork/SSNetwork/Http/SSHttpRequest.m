//
//  HZHttpRequest.m
//  HZNetWork
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSHttpRequest.h"
#import "AFNetworking.h"
#import "SSCacheDataCenter.h"




@implementation SSHttpRequest
+ (instancetype)shareRequest
{
    static SSHttpRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSHttpRequest alloc] init];
    });
    return instance;
}

+ (AFHTTPSessionManager *)returnSessionManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AFHTTPSessionManager alloc] init];
          manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    });
    return manager;
}

#pragma mark -

- (void)requestWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult{
    [self requestWithConfig:requestConfig responseResult:responseResult progress:nil];
}
- (void)upLoadWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    requestConfig.requestType = RequestTypeUpLoad;
    [self requestWithConfig:requestConfig responseResult:responseResult progress:progress];
}


#pragma mark - 公共调用
- (void)extracted:(NSString *)cacheUrl requestConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult {
    [[SSCacheDataCenter sharedCenter]getHttpCacheDataFromCachePath:cacheUrl success:^(NSData *cacheData) {
        if (cacheData) {
            id myResult = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
            SSHttpResponse *response = [[SSHttpResponse alloc]init];
            response.responseResult = myResult;
            response.isCacheData = YES;
            responseResult(response,requestConfig);
            NSLog(@"\n----网络缓存数据----\n%@",myResult);
        }
    }];
}

- (void)requestWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    
    if (!requestConfig.requestUrl.length) {
        NSLog(@"请求链接为空");
        return;
    }
    
    //读取缓存
    if (requestConfig.cacheTime >= 0&&requestConfig.useCache) {
        NSString *cacheUrl;
        if (requestConfig.customCacheKey.length) {
            cacheUrl = requestConfig.customCacheKey;
        }else{
            cacheUrl = requestConfig.defaultCacheKey;
        }
        [self extracted:cacheUrl requestConfig:requestConfig responseResult:responseResult];
    }
        

     NSString *url = [requestConfig.requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:requestConfig.returnAllParam];

    
    AFHTTPSessionManager *  manager = [SSHttpRequest returnSessionManager];
    //是否json表单请求
    if (requestConfig.requestParamsType == RequestParamsJsonType) {
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    ///超时
    [manager.requestSerializer setTimeoutInterval:requestConfig.timeoutInterval];
    ///请求头
    if (requestConfig.headerParams) {
        for (NSString *key in requestConfig.headerParams.allKeys) {
            [manager.requestSerializer setValue:requestConfig.headerParams[key] forHTTPHeaderField:key];
        }
        
    }
        
    NSURLSessionDataTask * task;
    __weak typeof(self) weakSelf = self;

    //get请求
    if (requestConfig.requestType == RequestTypeGet) {
        
        
        task  = [manager GET:url parameters:requestParam headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
            
        }];
        

        
    }
    //post请求
    if (requestConfig.requestType == RequestTypePost) {
        
        
        task  = [manager POST:url parameters:requestParam headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
            
        }];
        
        
    }
    //上传文件
    if (requestConfig.requestType == RequestTypeUpLoad) {
        
        
        if (!(requestConfig.fileDatas.count==requestConfig.names.count&&
              requestConfig.fileDatas.count==requestConfig.mimeTypes.count)) {
            NSLog(@"文件上传的数组要对应");
            return;
        }
        
        task = [manager POST:url parameters:requestParam headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 给上传的文件命名
            
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
            for (int i=0; i<requestConfig.fileDatas.count; i++) {
                NSString * manyfileName =[NSString stringWithFormat:@"%@_%d",@(timeInterval),i];
                [formData appendPartWithFileData:requestConfig.fileDatas[i] name:requestConfig.names[i] fileName:manyfileName mimeType:requestConfig.mimeTypes[i]];
                
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float myProgress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"上传文件进度：%lf",myProgress);
            progress(uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
            
        }];
        
        
    }
    requestConfig.dataTask = task;
    
}

#pragma mark - 处理数据

- (void)dealResponseWithRequestConfig:(SSHttpRequestConfig *)requestConfig
                                 task:(NSURLSessionDataTask *)task
                       responseObject:(id)responseObject
                                error:(NSError *)error
                       responseResult:(ResponseResult)responseResult{
    
    NSLog(@"\n----请求连接-----\n%@", requestConfig.paramUrl);
    NSLog(@"\n----请求参数-----\n %@",requestConfig.returnAllParam);

    [SSHttpResponse handelResult:responseObject error:error requestConfig:requestConfig];
    
    if (error) {
        SSHttpResponse *response = [SSHttpResponse new];
        response.responseError = error;
        responseResult(response,requestConfig);
    }else if([responseObject isKindOfClass:[NSDictionary class]]){
        SSHttpResponse *response = [SSHttpResponse new];
        response.responseResult = responseObject;
        responseResult(response,requestConfig);
        
        ///缓存数据
        if (requestConfig.cacheTime >= 0&&requestConfig.useCache) {
            NSString *cacheUrl;
            if (requestConfig.customCacheKey.length) {
                cacheUrl = requestConfig.customCacheKey;
            }else{
                cacheUrl = requestConfig.defaultCacheKey;
            }
            NSData *resultData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            
            [[SSCacheDataCenter sharedCenter]saveHttpCacheData:resultData cachePath:cacheUrl cacheTime:requestConfig.cacheTime];
        }
//        ///数据返回成功才缓存数据
//        if ([responseObject[@"code"] integerValue] == HttpResponseSuccess) {
//
//        }
    }
    
    
}




@end
