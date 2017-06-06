//
//  JXScheduler.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXScheduler.h"

@implementation JXScheduler



- (void)scheduleActionRepeatedly:(Action)action
                        interval:(NSTimeInterval)interval
                    endCondition:(EndCondition)endCondition {
    if (self.timer != nil || interval <= 0) {
        return;
    }
    
    self.action = action;
    self.endCondition = endCondition;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(doAction)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)doAction {
    if (!self.action || !self.endCondition || self.endCondition()) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    self.action();
}

@end
