//
//  HZHttpRequestConfig.m
//  HZNetWork
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSHttpRequestConfig.h"
#import "SSHttpConfig.h"


@implementation SSHttpCustomObject

@end


@implementation SSHttpRequestConfig
- (id)init{
    if (self = [super init]) {
    
    }
    
    return self;
}
- (NSString *)defaultCacheKey{
    return self.paramUrl;
}

- (void)setRequestUrl:(NSString *)requestUrl{
    if ([requestUrl containsString:@"http"]) {
        _requestUrl = requestUrl;
    }else{
        
        if ([SSHttpConfig shareConfig].httpServiceUrl) {
            _requestUrl = [[SSHttpConfig shareConfig].httpServiceUrl stringByAppendingPathComponent:requestUrl];
        }else{
            _requestUrl = requestUrl;
        }
    }
}

- (NSDictionary *)headerParams{
    if (_headerParams) {
        return _headerParams;
    }
    return  [SSHttpConfig shareConfig].headerParamsConfig()?:nil;
}


- (NSDictionary *)unifiedParams{
    if (_unifiedParams) {
        return _unifiedParams;
    }
    return [SSHttpConfig shareConfig].unifiedParamsConfig()?:nil;
}

- (NSTimeInterval)cacheTime{
    if (_cacheTime!=0) {
        return _cacheTime;
    }
    return [SSHttpConfig shareConfig].cacheTime;
}

- (NSTimeInterval)timeoutInterval{
    if (_timeoutInterval!=0) {
        return _timeoutInterval;
    }
    return [SSHttpConfig shareConfig].timeoutInterval;
}

- (RequestParamsType)requestParamsType{
    if (_requestParamsType==RequestParamsJsonType) {
        return _requestParamsType;
    }
    return [SSHttpConfig shareConfig].requestParamsType;
}


- (NSString *)paramUrl{
    if (!_requestUrl.length) {
        return @"";
    }
    return [self urlDictToStringWithUrlStr:_requestUrl paramDict:[self returnAllParam]];
}


- (NSDictionary *)returnAllParam{
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:self.paramDict];
    if (self.unifiedParams) {
        [requestParam addEntriesFromDictionary:self.unifiedParams];
    }
    return requestParam;
}


- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr paramDict:(NSDictionary *)paramDict{
   
    
    NSArray *allkeys = [[self returnAllParam] allKeys];
    
    NSArray *sortArray = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *parts = [NSMutableArray array];
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *encodedKey = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [[[[self returnAllParam] objectForKey:obj]description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    
    queryString =  queryString ? [NSString stringWithFormat:@"%@", queryString] : @"";
    
    NSString * pathStr = @"";
    if (![urlStr containsString:@"?"]) {
        pathStr =[NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    }else{
        pathStr =[NSString stringWithFormat:@"%@%@",urlStr,queryString];
    }
    return pathStr;
}

@end




