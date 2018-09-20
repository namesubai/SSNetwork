//
//  HZHttpRequest.h
//  HZNetWork
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHttpRequestConfig.h"
#import "SSHttpResponse.h"

typedef void (^ResponseResult)(SSHttpResponse *response,SSHttpRequestConfig *requestConfig);
typedef void (^LoadProgress)(NSProgress *uploadProgress);


@interface SSHttpRequest : NSObject


+ (instancetype)shareRequest;
///get,post
- (void)requestWithConfig:(SSHttpRequestConfig *)requestConfig
           responseResult:(ResponseResult)responseResult;
///上传
- (void)upLoadWithConfig:(SSHttpRequestConfig *)requestConfig
          responseResult:(ResponseResult)responseResult
                progress:(LoadProgress)progress;

@end
