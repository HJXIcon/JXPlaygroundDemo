//
//  JXAdaptationTool.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAdaptationTool.h"
#import "JXAdaptationManager.h"


@implementation JXAdaptationTool

+ (CGFloat)scaleForValue:(CGFloat)value
{
    return [[JXAdaptationManager manager] scaleForValue:value];
}

+ (CGFloat)scaleHeightWithRect:(CGRect)rect
{
    return [[JXAdaptationManager manager] scaleForValue:CGRectGetHeight(rect)];
}

+ (CGRect)scaleSizeWithRect:(CGRect)rect
{
    rect.size = [[JXAdaptationManager manager] scaleCGSize:rect.size];
    return rect;
}

+ (CGRect)scaleRectWithRect:(CGRect)rect
{
    return [[JXAdaptationManager manager] scaleCGRect:rect];
}


+ (CGFloat)scaleFontWithValue:(CGFloat)value
{
    return value + [[JXAdaptationManager manager] fontSizeOffset];
}



@end
