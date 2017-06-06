//
//  JXViewManager.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ViewManagerState) {
    ViewManagerStateSnapping = 0,
    ViewManagerStateMoving = (1 << 0),
    ViewManagerStateSwiping = (1 << 1),
};

@class JXSwipeAbleView;

@interface JXViewManager : NSObject

@property (nonatomic, readonly) ViewManagerState state;

@property (nonatomic) CGPoint point;

@property (nonatomic) CGVector direction;

- (instancetype)initWithView:(UIView *)view
               containerView:(UIView *)containerView
                       index:(NSUInteger)index
           miscContainerView:(UIView *)miscContainerView
                    animator:(UIDynamicAnimator *)animator
               swipeableView:(JXSwipeAbleView *)swipeableView;

- (void)setStateSnapping:(CGPoint)point;

- (void)setStateMoving:(CGPoint)point;

- (void)setStateSwiping:(CGPoint)point direction:(CGVector)directionVector;

- (void)setStateSnappingDefault;

- (void)setStateSnappingAtContainerViewCenter;


@end
