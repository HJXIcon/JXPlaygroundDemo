//
//  UIViewController+JXPopupViewController.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXPopupAnimation <NSObject>
@required
- (void)showView:(UIView*)popupView overlayView:(UIView*)overlayView;
- (void)dismissView:(UIView*)popupView overlayView:(UIView*)overlayView completion:(void (^)(void))completion;

@end


@interface UIViewController (JXPopupViewController)


@property (nonatomic, strong, readonly) UIView *JXPopupView;
@property (nonatomic, strong, readonly) UIView *JXOverlayView;
@property (nonatomic, strong, readonly) id<JXPopupAnimation> JXPopupAnimation;

// default click background to disappear
- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation;
- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation dismissed:(void(^)(void))dismissed;

- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation backgroundClickable:(BOOL)clickable;
- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void(^)(void))dismissed;

- (void)jx_dismissPopupView;
- (void)jx_dismissPopupViewWithanimation:(id<JXPopupAnimation>)animation;

@end


#pragma mark - *** UIView 分类
@interface UIView (JXPopupViewController)
@property (nonatomic, weak, readonly) UIViewController *jxPopupViewController;

@end
