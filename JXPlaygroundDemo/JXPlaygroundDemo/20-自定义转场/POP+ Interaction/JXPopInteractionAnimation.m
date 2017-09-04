//
//  JXPopInteractionAnimation.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/4.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopInteractionAnimation.h"

@implementation JXPopInteractionAnimation

// 转场的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

// 转场动画实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 通过 key 取到 fromVC 和 toVC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 把 toVC 加入到 containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    // 一些动画要用的的数据
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 动画过程
    if (toVC.isBeingPresented) {
        toVC.view.frame = CGRectOffset(finalFrame, 0, -finalFrame.size.height);
        [UIView animateWithDuration:duration
                         animations:^{
                             toVC.view.frame = finalFrame;
                         }
                         completion:^(BOOL finished) {
                             // 结束后要通知系统
                             [transitionContext completeTransition:YES];
                         }];
    }
    
    if (fromVC.isBeingDismissed) {
        [containerView sendSubviewToBack:toVC.view];
        [UIView animateWithDuration:duration
                         animations:^{
                             fromVC.view.frame = CGRectOffset(finalFrame, 0, -finalFrame.size.height);
                         }
                         completion:^(BOOL finished) {
                             // dismiss 动画添加了手势后可能出现转场取消的状态，所以要根据状态来判定是否完成转场
                             BOOL isComplete = ![transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:isComplete];
                         }];
    }
    
}

@end
