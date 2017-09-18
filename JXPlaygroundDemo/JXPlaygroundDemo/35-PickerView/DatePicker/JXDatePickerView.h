//
//  JXDatePickerView.h
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/18.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    JXDatePickerStyleShowYearMonthDayHourMinuteSecond  = 0,
    JXDatePickerStyleShowYearMonthDayHourMinute,
    JXDatePickerStyleShowYearMonthDay,
    
    JXDatePickerStyleShowMonthDayHourMinute,
    JXDatePickerStyleShowMonthDay,
    
    JXDatePickerStyleShowHourMinuteSecond,
    JXDatePickerStyleShowHourMinute
    
}JXDatePickerStyle;

@interface JXDatePickerView : UIView
/** 年月日时分秒字体颜色 */
@property (nonatomic, strong) UIColor *themeColor;
/** 限制最大时间（没有设置默认2049） */
@property (nonatomic, retain) NSDate *maxLimitDate;//
/** 限制最小时间（没有设置默认1970） */
@property (nonatomic, retain) NSDate *minLimitDate;//

@property (nonatomic, assign) JXDatePickerStyle datePickerStyle;


+ (instancetype)datePickerViewWithCompleteBlock:(void(^)(NSDate *))completeBlock;

+ (instancetype)datePickerViewWithCurrentDate:(NSDate *)currentDate CompleteBlock:(void (^)(NSDate *))completeBlock;

+ (instancetype)datePickerViewWithCurrentDate:(NSDate *)currentDate maxYear:(NSUInteger)maxYear minYear:(NSUInteger)minYear CompleteBlock:(void (^)(NSDate *))completeBlock;

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;

- (void)show;
- (void)dismiss;

@end
