//
//  NSString+CalculationAttrStrHeight.h
//  FishingWorld
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CalculationAttrStrHeight)
//计算出来的尺寸有误差
/**
 富文本高度处理
 
 @param str 文本字符串
 @param with 空间宽度
 */
-(CGFloat)calculatAttrStrHeight:(NSString *)str andWith:(CGFloat)with;
-(CGFloat)calculatAttrStrHeight:(NSString *)str andWith:(CGFloat)with andFont:(UIFont *)font;
-(CGFloat)calculatAttrStrWith:(NSString *)str andHeight:(CGFloat)height andFont:(UIFont *)font;
@end
