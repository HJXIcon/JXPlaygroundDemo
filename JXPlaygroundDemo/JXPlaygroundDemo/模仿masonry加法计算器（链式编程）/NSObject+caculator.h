//
//  NSObject+caculator.h
//  模仿masonry加法计算器
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JXCaculatorMaker;
@interface NSObject (caculator)

+ (float)makeCaculators:(void(^)(JXCaculatorMaker *maker))caculatorMaker;
@end
