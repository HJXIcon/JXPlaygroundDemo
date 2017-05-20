//
//  JXCaculator.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用函数式编程实现，写一个加法计算器,并且加法计算器自带判断是否等于某个值.
 */
@interface JXCaculator : NSObject

@property(nonatomic, assign) BOOL isEqule;
@property(nonatomic, assign) float result;

- (JXCaculator *)caculator:(float(^)(float result))caculator;
- (JXCaculator *)equle:(BOOL(^)(float result))operation;


@end
