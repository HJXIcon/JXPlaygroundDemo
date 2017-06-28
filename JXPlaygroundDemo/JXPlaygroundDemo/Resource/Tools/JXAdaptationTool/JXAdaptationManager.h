//
//  JXAdaptationManager.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JXAdaptationManager : NSObject


// CGFloat
- (CGFloat)scaleForValue:(CGFloat)value;
// CGSize
- (CGSize)scaleCGSize:(CGSize)size;
// CGPoint
- (CGPoint)scaleCGPoint:(CGPoint)point;
// CGRect
- (CGRect)scaleCGRect:(CGRect)rect;

+ (JXAdaptationManager *)manager;

// 获取屏幕缩放比例
- (CGFloat)getScaleRate;


@end
