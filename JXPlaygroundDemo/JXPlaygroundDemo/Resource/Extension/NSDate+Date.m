//
//  NSDate+Date.m
//  BuDeJie
//
//  Created by xmg on 16/5/4.
//  Copyright © 2016年 xmg. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)
- (BOOL)isThisYear
{
    // 判断是否是今年
    // 获取日历对象
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    // 获取发布日期组件
    NSDateComponents *cmp = [currentCalendar components:NSCalendarUnitYear fromDate:self];
    // 获取当前日期组件
    NSDateComponents *cmpCurrent = [currentCalendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return cmp.year == cmpCurrent.year;
}
- (BOOL)isThisToday
{
    // 判断是否是今天
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    return [currentCalendar isDateInToday:self];
}

- (BOOL)isThisYesterday
{
    // 判断是否是昨天
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    return [currentCalendar isDateInYesterday:self];
}

- (NSDateComponents *)detalDateWithNow
{
    // 判断下发布日期 与 当前日期 小时，分差值
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 获取两个日期的差值，获取发布日期与当前日期差值
    return [currentCalendar components:unit  fromDate:self toDate:[NSDate date] options:NSCalendarWrapComponents];
}
@end
