//
//  JXSwipeCardView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXSwipeCardView.h"

#define ACTION_MARGIN 120 //
#define SCALE_STRENGTH 4 // 缩放
#define SCALE_MAX .93 //
#define ROTATION_MAX 1 //
#define ROTATION_STRENGTH 320 //
#define ROTATION_ANGLE M_PI/8 // 旋转角度

@interface JXSwipeCardView ()
@property(nonatomic, assign) CGFloat xFromCenter;
@property(nonatomic, assign) CGFloat yFromCenter;

@end

@implementation JXSwipeCardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupView];
        
        _information = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 100)];
        _information.text = @"no info given";
        [_information setTextAlignment:NSTextAlignmentCenter];
        _information.textColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:_panGestureRecognizer];
        [self addSubview:_information];
        
        _overlayView = [[JXSwipeOverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        _overlayView.alpha = 0;
        [self addSubview:_overlayView];
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}


#pragma mark - Actions
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{

    _xFromCenter = [gestureRecognizer translationInView:self].x;
    _yFromCenter = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            
            // 1.旋转 | 位置
            CGFloat rotationStrength = MIN(_xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            
            self.center = CGPointMake(self.originalPoint.x + _xFromCenter, self.originalPoint.y + _yFromCenter);
            
            // 2.形变
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            
            // 3.遮盖
            [self updateOverlay:_xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

/// 更新遮盖
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        _overlayView.mode = JXSwipeOverlayViewModeRight;
    } else {
        _overlayView.mode = JXSwipeOverlayViewModeLeft;
    }
    
    _overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

/// 之后的动画
- (void)afterSwipeAction
{
    if (_xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (_xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             _overlayView.alpha = 0;
                         }];
    }
}



- (void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2 *_yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    if ([self.delegate respondsToSelector:@selector(cardSwipedRight:)]) {
         [self.delegate cardSwipedRight:self];
    }
    
    JXLog(@"YES");
}


- (void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*_yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    if ([self.delegate respondsToSelector:@selector(cardSwipedLeft:)]) {
        
        [self.delegate cardSwipedLeft:self];
    }
    
    
    JXLog(@"NO");
}

#pragma mark - 暴露方法

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    if ([self.delegate respondsToSelector:@selector(cardSwipedRight:)]) {
        [self.delegate cardSwipedRight:self];
    }
    
    JXLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    
    if ([self.delegate respondsToSelector:@selector(cardSwipedLeft:)]) {
        [self.delegate cardSwipedLeft:self];
    }
    
    
    JXLog(@"NO");
}


@end
