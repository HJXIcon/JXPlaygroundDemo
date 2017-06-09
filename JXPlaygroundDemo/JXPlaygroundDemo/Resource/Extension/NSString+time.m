//
//  NSString+time.m
//  FishingWorld
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 zhuya. All rights reserved.
//

#import "NSString+time.h"
#import "NSDate+Date.h"


@implementation NSString (time)

// 返回时间字符串
+ (NSString *)timeStringWithCreateDateString:(NSString *)timeline
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeline doubleValue]];
    
    
    // 获取发布日期对象
    // NSDateFormatter:日期字符串转 日期 ， 日期 转 日期字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 2015-08-24 19:12:20
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateStr = [fmt stringFromDate:date];
    NSDate *createDate = [fmt dateFromString:dateStr];
    
    NSDateComponents *detalCmp = [createDate detalDateWithNow];
    
    
    if ([createDate isThisYear]) {
        if ([createDate isThisToday]) {
            
            if (detalCmp.hour >= 1) { // 大于1小时
                
                dateStr = [NSString stringWithFormat:@"%ld小时前",detalCmp.hour];
                
            } else if (detalCmp.minute > 1) { // 大于1分钟
                
                dateStr = [NSString stringWithFormat:@"%ld分钟前",detalCmp.minute];
                
            } else { // 刚刚
                dateStr = @"刚刚";
            }
            
        } else if ([createDate isThisYesterday]) { // 发布日期 -> 昨天 19:20:20
            fmt.dateFormat = @"昨天 HH:mm:ss";
            dateStr = [fmt stringFromDate:createDate];
        } else { // 昨天之前 05-01 19:12:20
            
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            dateStr = [fmt stringFromDate:createDate];
        }
        
    }
    
    return dateStr;
}

+ (NSString *)timeStringWithCreateDateTwoString:(NSString *)timeline
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeline doubleValue]];
    
    
    // 获取发布日期对象
    // NSDateFormatter:日期字符串转 日期 ， 日期 转 日期字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 2015-08-24 19:12:20
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateStr = [fmt stringFromDate:date];
    NSDate *createDate = [fmt dateFromString:dateStr];
    
    NSDateComponents *detalCmp = [createDate detalDateWithNow];
    
    
    if ([createDate isThisYear]) {
        if ([createDate isThisToday]) {
            
            if (detalCmp.hour >= 1) { // 大于1小时
                
                dateStr = [NSString stringWithFormat:@"%ld小时前",detalCmp.hour];
                
            } else if (detalCmp.minute > 1) { // 大于1分钟
                
                dateStr = [NSString stringWithFormat:@"%ld分钟前",detalCmp.minute];
                
            } else { // 刚刚
                dateStr = @"刚刚";
            }
            
        } else if ([createDate isThisYesterday]) { // 发布日期 -> 昨天 19:20:20
            fmt.dateFormat = @"昨天 HH:mm";
            dateStr = [fmt stringFromDate:createDate];
        } else { // 昨天之前 05-01 19:12:20
            
            fmt.dateFormat = @"yyyy.MM.dd HH:mm";
            dateStr = [fmt stringFromDate:createDate];
        }
        
    }
    
    return dateStr;
}

// 根据一个时间日期字符串算年龄
+ (NSString *)timeAgeStringWithDateString:(NSString *)timeline
{
    NSString *birth = timeline;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
  
    return [NSString stringWithFormat:@"%d", age];
}

// 返回年月日时间字符串
+ (NSString *)timeStringWithCreateHaveYearDateString:(NSString *)timeline
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeline doubleValue]];
    
    
    // 获取发布日期对象
    // NSDateFormatter:日期字符串转 日期 ， 日期 转 日期字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 2015-08-24 19:12:20
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateStr = [fmt stringFromDate:date];
    NSDate *createDate = [fmt dateFromString:dateStr];

    fmt.dateFormat = @"yyyy年MM月dd日";
    dateStr = [fmt stringFromDate:createDate];
    
    return dateStr;
}

/*
 NSCalendar:日历 判断下是否是今天，昨天 ，指定一个日期，就能获取这个日期的日期组件 4.获取两个日期的差值
 NSDate:日期
 NSDateComponents:日期组件（获取当前日期，年，月，日，分，小时，秒）
 今年
 今天
 1分钟之前 : 刚刚
 1小时之前  : 20分钟之前
 24小时之前  : 1小时之前
 
 昨天     ： 昨天 19:20:20
 昨天之前 ：05-01 19:12:20
 
 非今年 ： 2015-08-24 19:12:20
 
 1.判断到底是不是今年：年份是否相等 2016 == 2015
 2.判断 今天 昨天 昨天之前
 */


//获取当前时间的时间戳
+ (NSString *)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}


#pragma mark - 是否含有中文
- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}


@end
