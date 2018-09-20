//
//  TestModel.m
//  SSNetwork
//
//  Created by ThisRhythm on 2018/9/19.
//  Copyright © 2018年 ThisRhythm. All rights reserved.
//

#import "TestModel.h"
@implementation Test_Arr_Model

@end

@implementation TestModel

- (NSDictionary *)ss_setupObjectClassInArray{
    return @{@"array":[Test_Arr_Model class]};
}

- (NSDictionary *)ss_replacedKeyFromPropertyName{
    return @{@"id":@"replaceName"};
}

@end
