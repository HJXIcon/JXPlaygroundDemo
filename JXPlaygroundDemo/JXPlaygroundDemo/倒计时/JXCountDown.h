//
//  JXCountDown.h
//  JXPlaygroundDemo
//
//  Created by HJXICon on 2018/2/23.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXCountDown : NSObject
///用NSDate日期倒计时
- (void)jx_countDownWithStratDate:(NSDate *)startDate
                   finishDate:(NSDate *)finishDate
                completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///用时间戳倒计时
- (void)jx_countDownWithStratTimeStamp:(long long)starTimeStamp
                   finishTimeStamp:(long long)finishTimeStamp
                     completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///每秒走一次，回调block
- (void)jx_countDownWithPER_SECBlock:(void (^)())PER_SECBlock;

/// 倒计时秒
- (void)jx_countDownWithTime:(NSInteger)time
                PER_SECBlock:(void (^)(NSInteger lefTime))PER_SECBlock;

/// 主动销毁定时器
- (void)jx_destoryTimer;
- (NSDate *)jx_dateWithLongLong:(long long)longlongValue;
@end
