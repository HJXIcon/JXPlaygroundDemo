//
//  JXSuspension.h
//  JXSuspension
//
//  Created by HJXICon on 2018/3/2.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JXSuspension : NSObject

/// 默认是40 * 40
@property (nonatomic, assign) CGSize windowSize;

/// 起始中心 默认是windowSize.height/3, 100
@property (nonatomic, assign) CGPoint windowOriginCenter;
/// 不活跃透明度 默认0.6
@property (nonatomic, assign) CGFloat inertiaAlpha;
/// 改变状态的时间 默认2.0
@property (nonatomic, assign) CGFloat stateDuration;
/// 停靠距离 默认20
@property (nonatomic, assign) CGFloat hangingOnMargin;


/// 移除
- (void)removeFromApplication;


@end
