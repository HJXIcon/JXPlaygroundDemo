//
//  JXViewManager.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXViewManager.h"
#import "JXPanGestureRecognizer.h"
#import "JXSwipeAbleViewMovement.h"
#import "JXSwipeAbleView.h"
#import "Utils.h"


static const CGFloat kAnchorViewWidth = 1000;

@interface JXViewManager ()

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *miscContainerView;
@property (weak, nonatomic) JXSwipeAbleView *swipeableView;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIView *anchorView;

/***! UIDynamicBehavior子类  */
/// 迅猛移动弹跳摆动(捕捉行为)
@property (strong, nonatomic) UISnapBehavior *snapBehavior;
// 附着行为
@property (strong, nonatomic) UIAttachmentBehavior *viewToAnchorViewAttachmentBehavior;
// 附着行为
@property (strong, nonatomic) UIAttachmentBehavior *anchorViewToPointAttachmentBehavior;
// 推动行为
@property (strong, nonatomic) UIPushBehavior *pushBehavior;


@end
@implementation JXViewManager


- (instancetype)initWithView:(UIView *)view
               containerView:(UIView *)containerView
                       index:(NSUInteger)index
           miscContainerView:(UIView *)miscContainerView
                    animator:(UIDynamicAnimator *)animator
               swipeableView:(JXSwipeAbleView *)swipeableView {
    self = [super init];
    if (self) {
        self.view = view;
        self.containerView = containerView;
        self.miscContainerView = miscContainerView;
        self.animator = animator;//动态效果
        self.swipeableView = swipeableView;
        
        [view addGestureRecognizer:
         [[JXPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
        _anchorView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAnchorViewWidth, kAnchorViewWidth)];
        _anchorView.hidden = NO;
        [miscContainerView addSubview:_anchorView];
        [containerView insertSubview:view atIndex:index];
    }
    return self;
}


- (void)dealloc {
    for (UIGestureRecognizer *aGestureRecognizer in _view.gestureRecognizers) {
        if ([aGestureRecognizer isKindOfClass:[JXPanGestureRecognizer class]]) {
            [_view removeGestureRecognizer:aGestureRecognizer];
        }
    }
    
    if (_snapBehavior) {
        [_animator removeBehavior:_snapBehavior];
    }
    if (_viewToAnchorViewAttachmentBehavior) {
        [_animator removeBehavior:_viewToAnchorViewAttachmentBehavior];
    }
    if (_anchorViewToPointAttachmentBehavior) {
        [_animator removeBehavior:_anchorViewToPointAttachmentBehavior];
    }
    if (_pushBehavior) {
        [_animator removeBehavior:_pushBehavior];
    }
    
    [_anchorView removeFromSuperview];
    [_view removeFromSuperview];
}


#pragma mark - Action

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (!_swipeableView) {
        return;
    }
    /*!
     translationInView : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
     locationInView ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
     velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一体的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动。
     */
    CGPoint translation = [recognizer translationInView:_containerView];
    
    CGPoint location = [recognizer locationInView:_containerView];
    
    CGPoint velocity = [recognizer velocityInView:_containerView];
    
    JXSwipeAbleViewMovement *movement =
    [[JXSwipeAbleViewMovement alloc] initWithLocation:location
                                           tranlation:translation
                                             velocity:velocity];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self setStateMoving:location];
        [self didStartSwipingView:_view movement:movement];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self setStateMoving:location];
        [self swipingView:_view movement:movement];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        if (_state != ViewManagerStateMoving) {
            return;
        }
        if ([_swipeableView.swipingDeterminator shouldSwipeView:_view
                                                       movement:movement
                                                  swipeableView:_swipeableView]) {
            CGVector directionVector = CGVectorFromCGPoint(CGPointMultiply(
                                                                           CGPointNormalized(translation),
                                                                           MAX(CGPointMagnitude(velocity), _swipeableView.minVelocityInPointPerSecond)));
            [_swipeableView swipeTopViewFromPoint:location inDirection:directionVector];
        } else {
            [self setStateSnappingAtContainerViewCenter];
            [self didCancelSwipingView:_view movement:movement];
        }
        
        [self didEndSwipingView:_view movement:movement];
    }
}

- (void)setStateSnapping:(CGPoint)point {
    if (_state == ViewManagerStateMoving) {
        [self detachView];
        [self snapView:point];
    }
    if (_state == ViewManagerStateSwiping) {
        [self unpushView];
        [self detachView];
        [self snapView:point];
    }
    _state = ViewManagerStateSnapping;
}

- (void)setStateMoving:(CGPoint)point {
    if (_state == ViewManagerStateSnapping) {
        [self unsnapView];
        [self attachView:point];
    }
    if (_state == ViewManagerStateMoving) {
        [self moveView:point];
    }
    _state = ViewManagerStateMoving;
}

- (void)setStateSwiping:(CGPoint)point direction:(CGVector)directionVector {
    if (_state == ViewManagerStateSnapping) {
        [self unsnapView];
        [self attachView:point];
        [self pushViewFromPoint:point inDirection:directionVector];
    }
    if (_state == ViewManagerStateMoving) {
        [self pushViewFromPoint:point inDirection:directionVector];
    }
    _state = ViewManagerStateSwiping;
}

- (void)setStateSnappingDefault {
    [self setStateSnapping:[_view convertPoint:_view.center fromView:_view.superview]];
}

- (void)setStateSnappingAtContainerViewCenter {
    if (!_swipeableView) {
        [self setStateSnappingDefault];
        return;
    }
    [self setStateSnapping:[_containerView convertPoint:_swipeableView.center
                                               fromView:_swipeableView.superview]];
}

#pragma mark - UIDynamicAnimationHelpers

- (void)snapView:(CGPoint)point {
    _snapBehavior = [[UISnapBehavior alloc] initWithItem:_view snapToPoint:point];
    _snapBehavior.damping = 0.75f; /* Medium oscillation */
    [self addBehavior:_snapBehavior];
}

- (void)unsnapView {
    [self removeBehavior:_snapBehavior];
}

- (void)attachView:(CGPoint)point {
    _anchorView.center = point;
    _anchorView.backgroundColor = [UIColor blueColor];
    _anchorView.hidden = YES;
    
    // attach aView to anchorView
    CGPoint p = _view.center;
    _viewToAnchorViewAttachmentBehavior =
    [[UIAttachmentBehavior alloc] initWithItem:_view
                              offsetFromCenter:UIOffsetMake(-(p.x - point.x), -(p.y - point.y))
                                attachedToItem:_anchorView
                              offsetFromCenter:UIOffsetZero];
    _viewToAnchorViewAttachmentBehavior.length = 0;
    
    // attach anchorView to point
    _anchorViewToPointAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:_anchorView
                                                                     offsetFromCenter:UIOffsetZero
                                                                     attachedToAnchor:point];
    _anchorViewToPointAttachmentBehavior.damping = 100;
    _anchorViewToPointAttachmentBehavior.length = 0;
    
    [self addBehavior:_viewToAnchorViewAttachmentBehavior];
    [self addBehavior:_anchorViewToPointAttachmentBehavior];
}

- (void)moveView:(CGPoint)point {
    if (!_viewToAnchorViewAttachmentBehavior || !_anchorViewToPointAttachmentBehavior) {
        return;
    }
    _anchorViewToPointAttachmentBehavior.anchorPoint = point;
}

- (void)detachView {
    if (!_viewToAnchorViewAttachmentBehavior || !_anchorViewToPointAttachmentBehavior) {
        return;
    }
    [self removeBehavior:_viewToAnchorViewAttachmentBehavior];
    [self removeBehavior:_anchorViewToPointAttachmentBehavior];
}

- (void)pushViewFromPoint:(CGPoint)point inDirection:(CGVector)direction {
    if (!_viewToAnchorViewAttachmentBehavior || !_anchorViewToPointAttachmentBehavior) {
        return;
    }
    
    [self removeBehavior:_anchorViewToPointAttachmentBehavior];
    
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ _anchorView ]
                                                     mode:UIPushBehaviorModeInstantaneous];
    _pushBehavior.pushDirection = direction;
    [self addBehavior:_pushBehavior];
}

- (void)unpushView {
    if (!_pushBehavior) {
        return;
    }
    [self removeBehavior:_pushBehavior];
}

- (void)addBehavior:(UIDynamicBehavior *)behavior {
    [_animator addBehavior:behavior];
}

/// 移除1个物理仿真行为
- (void)removeBehavior:(UIDynamicBehavior *)behavior {
    [_animator removeBehavior:behavior];
}

#pragma mark - ()

- (void)didStartSwipingView:(UIView *)view movement:(JXSwipeAbleViewMovement *)movement {
    if ([self.swipeableView.delegate
         respondsToSelector:@selector(swipeableView:didStartSwipingView:atLocation:)]) {
        [self.swipeableView.delegate swipeableView:self.swipeableView
                               didStartSwipingView:view
                                        atLocation:movement.location];
    }
}

- (void)swipingView:(UIView *)view movement:(JXSwipeAbleViewMovement *)movement {
    if ([self.swipeableView.delegate
         respondsToSelector:@selector(swipeableView:swipingView:atLocation:translation:)]) {
        [self.swipeableView.delegate swipeableView:self.swipeableView
                                       swipingView:view
                                        atLocation:movement.location
                                       translation:movement.translation];
    }
}

- (void)didCancelSwipingView:(UIView *)view movement:(JXSwipeAbleViewMovement *)movement {
    if ([self.swipeableView.delegate respondsToSelector:@selector(swipeableView:didCancelSwipe:)]) {
        [self.swipeableView.delegate swipeableView:self.swipeableView didCancelSwipe:view];
    }
}

- (void)didEndSwipingView:(UIView *)view movement:(JXSwipeAbleViewMovement *)movement {
    if ([self.swipeableView.delegate
         respondsToSelector:@selector(swipeableView:didEndSwipingView:atLocation:)]) {
        [self.swipeableView.delegate swipeableView:self.swipeableView
                                 didEndSwipingView:view
                                        atLocation:movement.location];
    }
}



@end
