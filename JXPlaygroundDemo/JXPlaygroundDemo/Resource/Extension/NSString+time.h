//
//  NSString+time.h
//  FishingWorld
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 zhuya. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 时间处理
 */
@interface NSString (time)

/**
 时间处理，类似微信，就像多少分钟之前

 @param dateStr 创建时间轴
 
 格式： 03-19 22:12:34
 */
+ (NSString *)timeStringWithCreateDateString:(NSString *)timeline;

// 格式： 2003.03.19 22:12
+ (NSString *)timeStringWithCreateDateTwoString:(NSString *)timeline;


// 返回年月日时间字符串
+ (NSString *)timeStringWithCreateHaveYearDateString:(NSString *)timeline;


// 根据一个时间日期字符串算年龄
+ (NSString *)timeAgeStringWithDateString:(NSString *)timeline;


/**
 获取当前时间的时间戳

 @return 时间戳
 */
+ (NSString *)getCurrentTimestamp;

#pragma mark - 是否含有中文
- (BOOL)isChinese;//判断是否是纯汉字

- (BOOL)includeChinese;//判断是否含有汉字


@end
