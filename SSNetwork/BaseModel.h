//
//  BaseModel.h
//  SSNetwork
//
//  Created by ThisRhythm on 2018/9/19.
//  Copyright © 2018年 ThisRhythm. All rights reserved.
//

#import "SSHttpModel.h"

@interface BaseModel : SSHttpModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@end
