//
//  ViewController.m
//  SSNetwork
//
//  Created by ThisRhythm on 2018/9/18.
//  Copyright © 2018年 ThisRhythm. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   ///get请求
    [TestModel getRequestWithUrlStr:@""
                          paramDict:@{}
                      responseBlock:^(TestModel *dataObj, NSError *error, BOOL isCache) {
        
                      }];
    
    ///get请求可配置requestConfig
    [TestModel getRequestWithUrlStr:@"" paramDict:@{} requestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.useCache = YES;//缓存数据
        requestConfig.timeoutInterval = 20;///设置超时时间
        requestConfig.customCacheKey = @"";///自定义缓存路径
        
    } responseBlock:^(TestModel *dataObj, NSError *error, BOOL isCache) {
        
    }];
    
    ///post请求
    [TestModel postRequestWithUrlStr:@""
                           paramDict:@{}
                       responseBlock:^(id dataObj, NSError *error, BOOL isCache) {
        
                       }];
    
    ///post请求可配置requestConfig
    [TestModel postRequestWithUrlStr:@"" paramDict:@{} requestConfigHandle:^(SSHttpRequestConfig *requestConfig) {
        requestConfig.useCache = YES;//缓存数据
        requestConfig.timeoutInterval = 20;///设置超时时间
        requestConfig.customCacheKey = @"";///自定义缓存路径
    } responseBlock:^(id dataObj, NSError *error, BOOL isCache) {
        
    }];
    
    
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
