//
//  JXCaculator.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCaculator.h"

@implementation JXCaculator

- (JXCaculator *)caculator:(float(^)(float result))caculator{
    
    
    self.result = caculator(self.result);
    
    return self;
}


- (JXCaculator *)equle:(BOOL(^)(float result))operation{
    self.isEqule = operation(self.result);
    
    return self;
}

@end
