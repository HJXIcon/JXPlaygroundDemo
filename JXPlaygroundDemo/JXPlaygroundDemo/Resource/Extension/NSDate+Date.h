//
//  NSDate+Date.h
//  BuDeJie
//
//  Created by xmg on 16/5/4.
//  Copyright © 2013年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)

// 判断下是否是今年
- (BOOL)isThisYear;

// 判断下是否是今天
- (BOOL)isThisToday;

// 判断下是否是昨天
- (BOOL)isThisYesterday;

// 获取日期与当前日期差值
- (NSDateComponents *)detalDateWithNow;

@end
