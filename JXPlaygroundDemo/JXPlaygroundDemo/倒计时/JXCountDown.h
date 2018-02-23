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
- (void)countDownWithStratDate:(NSDate *)startDate
                   finishDate:(NSDate *)finishDate
                completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///用时间戳倒计时
- (void)countDownWithStratTimeStamp:(long long)starTimeStamp
                   finishTimeStamp:(long long)finishTimeStamp
                     completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///每秒走一次，回调block
- (void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock;
/// 主动销毁定时器
- (void)destoryTimer;
- (NSDate *)dateWithLongLong:(long long)longlongValue;
@end
