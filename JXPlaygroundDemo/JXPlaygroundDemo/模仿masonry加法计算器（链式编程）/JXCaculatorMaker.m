
//
//  JXCaculatorMaker.m
//  模仿masonry加法计算器
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCaculatorMaker.h"

@interface JXCaculatorMaker ()


@end

@implementation JXCaculatorMaker

- (JXCaculatorMaker *(^)(float))add{
    
    return ^JXCaculatorMaker *(float value){
        
        _result += value;
        
        return self;
    };
    
    
}





@end
