//
//  JXAdaptationTool.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

// skin
#define SkinScaleValue(A)  ([JXAdaptationTool scaleForValue:A])
#define SkinScaleHeight(A) ([JXAdaptationTool scaleRectWithRect:A])

#define SkinScaleSize(A)   ([JXAdaptationTool scaleSizeWithRect:A])

#define SkinScaleRect(A)   ([JXAdaptationTool scaleRectWithRect:A])

#define SkinGetFontSize(A) ([JXAdaptationTool scaleFontWithValue:A])


@interface JXAdaptationTool : NSObject

// 包装屏幕适配相关方法
+ (CGFloat)scaleForValue:(CGFloat)value;
+ (CGFloat)scaleHeightWithRect:(CGRect)rect;
+ (CGRect)scaleSizeWithRect:(CGRect)rect;
+ (CGRect)scaleRectWithRect:(CGRect)rect;
+ (CGFloat)scaleFontWithValue:(CGFloat)value;

@end
