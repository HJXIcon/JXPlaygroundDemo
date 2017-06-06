//
//  JXScheduler.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Action)(void);
typedef BOOL (^EndCondition)(void);

@interface JXScheduler : NSObject


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Action action;
@property (nonatomic, strong) EndCondition endCondition;

- (void)scheduleActionRepeatedly:(Action)action
                        interval:(NSTimeInterval)interval
                    endCondition:(EndCondition)endCondition;



@end
