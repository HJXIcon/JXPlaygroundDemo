//
//  JXPopInteraction.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/4.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopInteraction.h"

@interface JXPopInteraction ()
@property (nonatomic, weak)UIViewController *presentedVC;
@property (nonatomic, assign)BOOL shouldComplete;
@end

@implementation JXPopInteraction
// 给 viewController 的 view 添加手势
- (void)prepareForViewController:(UIViewController *)viewController {
    _presentedVC = viewController;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [viewController.view addGestureRecognizer:panGesture];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    // 动画的百分比
    CGFloat percent = 0.0;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 设置交互状态为 YES
            _interacting = YES;
            // 手势开始时要调用 dismiss
            [_presentedVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            // 计算百分比
            percent = -translation.y/_presentedVC.view.bounds.size.height;
            // 更新转场的进度 传入的参数值要在 0.0~1.0 之间
            [self updateInteractiveTransition:percent];
            // 如果滑动超过 30% 就视为转场完成
            _shouldComplete = (percent > 0.3);
            break;
        case UIGestureRecognizerStateCancelled:
            _interacting = NO;
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            _interacting = NO;
            if (_shouldComplete) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end
