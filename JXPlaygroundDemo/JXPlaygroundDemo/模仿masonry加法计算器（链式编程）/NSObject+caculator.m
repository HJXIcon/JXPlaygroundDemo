//
//  NSObject+caculator.m
//  模仿masonry加法计算器
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "NSObject+caculator.h"
#import "JXCaculatorMaker.h"

@implementation NSObject (caculator)

+ (float)makeCaculators:(void(^)(JXCaculatorMaker *maker))caculatorMaker{
    
    JXCaculatorMaker *maker = [[JXCaculatorMaker alloc]init];
    caculatorMaker(maker);
    
    return maker.result;
}

@end
