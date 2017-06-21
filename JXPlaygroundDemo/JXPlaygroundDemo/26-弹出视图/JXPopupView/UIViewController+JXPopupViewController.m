//
//  UIViewController+JXPopupViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "UIViewController+JXPopupViewController.h"
#import <objc/runtime.h>
#import "JXPopupBackgroundView.h"

#define kJXPopupView @"kJXPopupView"
#define kJXOverlayView @"kJXOverlayView"
#define kJXPopupViewDismissedBlock @"kJXPopupViewDismissedBlock"
#define KJXPopupAnimation @"KJXPopupAnimation"
#define kJXPopupViewController @"kJXPopupViewController"

static NSInteger const  kJXPopupViewTag = 8002;
static NSInteger const  kJXOverlayViewTag = 8003;


#pragma mark - *** JXPopupViewControllerPrivate + UIView
@interface UIView (JXPopupViewControllerPrivate)
@property (nonatomic, weak, readwrite) UIViewController *JXPopupViewController;
@end


@interface UIViewController (JXPopupViewControllerPrivate)
@property (nonatomic, retain) UIView *JXPopupView;
@property (nonatomic, retain) UIView *JXOverlayView;
@property (nonatomic, copy) void(^JXDismissCallback)(void);
@property (nonatomic, retain) id<JXPopupAnimation> popupAnimation;
- (UIView*)topView;
@end



@implementation UIViewController (JXPopupViewController)

#pragma public method

- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation{
    [self _presentPopupView:popupView animation:animation backgroundClickable:YES dismissed:nil];
}

- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation dismissed:(void (^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation backgroundClickable:YES dismissed:dismissed];
}

- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation backgroundClickable:(BOOL)clickable{
    [self _presentPopupView:popupView animation:animation backgroundClickable:clickable dismissed:nil];
}

- (void)jx_presentPopupView:(UIView *)popupView animation:(id<JXPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void (^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation backgroundClickable:clickable dismissed:dismissed];
}

- (void)jx_dismissPopupViewWithanimation:(id<JXPopupAnimation>)animation{
    [self _dismissPopupViewWithAnimation:animation];
}

- (void)jx_dismissPopupView{
    [self _dismissPopupViewWithAnimation:self.JXPopupAnimation];
}
#pragma mark - inline property
- (UIView *)JXPopupView {
    return objc_getAssociatedObject(self, kJXPopupView);
}

- (void)setJXPopupView:(UIViewController *)JXPopupView {
    objc_setAssociatedObject(self, kJXPopupView, JXPopupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)JXOverlayView{
    return objc_getAssociatedObject(self, kJXOverlayView);
}

- (void)setJXOverlayView:(UIView *)JXOverlayView {
    objc_setAssociatedObject(self, kJXOverlayView, JXOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(void))JXDismissCallback{
    return objc_getAssociatedObject(self, kJXPopupViewDismissedBlock);
}

- (void)setJXDismissCallback:(void (^)(void))JXDismissCallback{
    objc_setAssociatedObject(self, kJXPopupViewDismissedBlock, JXDismissCallback, OBJC_ASSOCIATION_COPY);
}

- (id<JXPopupAnimation>)JXPopupAnimation{
    return objc_getAssociatedObject(self, KJXPopupAnimation);
}

- (void)setJXPopupAnimation:(id<JXPopupAnimation>)JXPopupAnimation{
    objc_setAssociatedObject(self, KJXPopupAnimation, JXPopupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - view handle

- (void)_presentPopupView:(UIView*)popupView animation:(id<JXPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void(^)(void))dismissed{
    
    
    // check if source view controller is not in destination
    if ([self.JXOverlayView.subviews containsObject:popupView]) return;
    
    // fix issue #2
    if (self.JXOverlayView && self.JXOverlayView.subviews.count > 1) {
        [self _dismissPopupViewWithAnimation:nil];
    }
    
    self.JXPopupView = nil;
    self.JXPopupView = popupView;
    self.JXPopupAnimation = nil;
    self.JXPopupAnimation = animation;
    
    UIView *sourceView = [self _jx_topView];
    
    // customize popupView
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kJXPopupViewTag;
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add overlay
    if (self.JXOverlayView == nil) {
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.tag = kJXOverlayViewTag;
        overlayView.backgroundColor = [UIColor clearColor];
        
        // BackgroundView
        UIView *backgroundView = [[JXPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor clearColor];
        [overlayView addSubview:backgroundView];
        
        // Make the Background Clickable
        if (clickable) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jx_dismissPopupView)];
            [backgroundView addGestureRecognizer:tap];
        }
        self.JXOverlayView = overlayView;
    }
    
    [self.JXOverlayView addSubview:popupView];
    [sourceView addSubview:self.JXOverlayView];
    
    self.JXOverlayView.alpha = 1.0f;
    popupView.center = self.JXOverlayView.center;
    if (animation) {
        [animation showView:popupView overlayView:self.JXOverlayView];
    }
    
    [self setJXDismissCallback:dismissed];
    
}

- (void)_dismissPopupViewWithAnimation:(id<JXPopupAnimation>)animation{
    if (animation) {
        [animation dismissView:self.JXPopupView overlayView:self.JXOverlayView completion:^(void) {
            [self.JXOverlayView removeFromSuperview];
            [self.JXPopupView removeFromSuperview];
            self.JXPopupView = nil;
            self.JXPopupAnimation = nil;
            
            id dismissed = [self JXDismissCallback];
            if (dismissed != nil){
                ((void(^)(void))dismissed)();
                [self setJXDismissCallback:nil];
            }
        }];
    }else{
        [self.JXOverlayView removeFromSuperview];
        [self.JXPopupView removeFromSuperview];
        self.JXPopupView = nil;
        self.JXPopupAnimation = nil;
        
        id dismissed = [self JXDismissCallback];
        if (dismissed != nil){
            ((void(^)(void))dismissed)();
            [self setJXDismissCallback:nil];
        }
    }
}

-(UIView*)_jx_topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end

#pragma mark - UIView+JXPopupView
@implementation UIView (JXPopupViewController)
- (UIViewController *)jxPopupViewController {
    return objc_getAssociatedObject(self, kJXPopupViewController);
}

- (void)setJXPopupViewController:(UIViewController * _Nullable)JXPopupViewController {
    objc_setAssociatedObject(self, kJXPopupViewController, JXPopupViewController, OBJC_ASSOCIATION_ASSIGN);
}

@end



