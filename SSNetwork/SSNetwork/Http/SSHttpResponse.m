//
//  SSHttpResponse.m
//  SSNetwork
//
//  Created by yangsq on 2018/9/19.
//  Copyright © 2018年 yangsq. All rights reserved.
//

#import "SSHttpResponse.h"
#import "SSHttpRequestConfig.h"

@implementation SSHttpResponse
+ (void)handelResult:(id)result
               error:(NSError *)error
       requestConfig:(SSHttpRequestConfig *)requestConfig{
    
    if (error&&requestConfig.requestCustomObject.isAutoHandleError) {
        switch (error.code) {
            case NSURLErrorTimedOut:
            {
                NSLog(@"网络请求超时，请检查网络！");
            }
                break;
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorBadURL:
                
            {
                NSLog(@"当前网络不稳定，请检查网络!");
            }
                break;
                
            default:
                NSLog(@"发生错误，请稍后再试！");
                
                break;
        }
     
    }
    
    if (result && requestConfig.requestCustomObject.isAutoHandleResult) {
        ///处理代码
        ///例如登录失效,重新登录
        
    }
    
}
@end
