//
//  HZCacheBaseData.m
//  HZNetWork
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSCacheBaseData.h"

@implementation SSCacheBaseData
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.appVerSionString forKey:NSStringFromSelector(@selector(appVerSionString))];
    [aCoder encodeObject:self.expirationTime forKey:NSStringFromSelector(@selector(expirationTime))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.appVerSionString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVerSionString))];
    self.expirationTime = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(expirationTime))];
    
    return self;
}
@end
