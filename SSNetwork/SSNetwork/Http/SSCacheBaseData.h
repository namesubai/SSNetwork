//
//  HZCacheBaseData.h
//  HZNetWork
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSCacheBaseData : NSObject <NSSecureCoding>
///程序版本号
@property (nonatomic, copy) NSString *appVerSionString;
///缓存保存时的时间
@property (nonatomic, copy) NSString *expirationTime;
@end
