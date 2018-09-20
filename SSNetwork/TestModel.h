//
//  TestModel.h
//  SSNetwork
//
//  Created by ThisRhythm on 2018/9/19.
//  Copyright © 2018年 ThisRhythm. All rights reserved.
//

#import "BaseModel.h"

@interface Test_Arr_Model : NSObject

@end

@interface TestModel : BaseModel

@property (nonatomic, strong) NSArray <Test_Arr_Model *> *array;
@property (nonatomic, copy) NSString *replaceName;
@end
