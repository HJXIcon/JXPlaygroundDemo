//
//  FLPushView.m
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLPushView.h"

@interface FLPushView ()
{
    CGPoint     _beginPoint; // 记录拖动起始点
    CGPoint     _endPoint; // 记录终点
    CGPoint     _movePoint; // 记录移动过程中的点
    
    UIPushBehavior *_push; // 记录仿真行为
    
    UIImageView    *_finger; // 记录点按手指印
}
@end

@implementation FLPushView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. 添加手势识别
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [self addGestureRecognizer:pan];
        
        // 2. 添加仿真行为
        _push = [[UIPushBehavior alloc] initWithItems:@[self.box] mode:UIPushBehaviorModeInstantaneous];
        
        [self.animator addBehavior:_push];
        
        // 3. 添加碰撞检测
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.box]];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        
        [self.animator addBehavior:collision];
        
        // 4. 添加模拟点按手指
        _finger = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AttachmentPoint_Mask"]];
        _finger.hidden = YES;
        
        [self addSubview:_finger];
        
        _finger.tintColor = [UIColor blueColor]; // 设置为蓝色
        _finger.image = [_finger.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_finger setNeedsDisplay];
    }
    return self;
}

#pragma mark 滑动手势
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    
    if (UIGestureRecognizerStateBegan == gesture.state) {
        
        // 获取起始点
        _beginPoint = location;
        
        // 显示点按手指
        _finger.hidden = NO;
        _finger.center = _beginPoint;
        
    }else if (UIGestureRecognizerStateChanged == gesture.state){
        
        // 渲染拉伸路线
        _movePoint = location;
        
        [self setNeedsDisplay];
        
    }else if (UIGestureRecognizerStateEnded == gesture.state){
        
        // 如果起始点在box内，执行仿真动画
        if (CGRectContainsPoint(self.box.frame, _beginPoint)){
        
            // 设置推动仿真的属性
            _endPoint = location;
            
            CGPoint offset = CGPointMake(_beginPoint.x - _endPoint.x, _beginPoint.y - _endPoint.y);
            
            _push.active = YES;
            _push.angle = atan2f(offset.y, offset.x); // 角度
            _push.magnitude = sqrtf(offset.x * offset.x + offset.y * offset.y) / 50; // 推动力量
            
        }
        
        // 隐藏点按手指
        _finger.hidden = YES;
        
        // 清楚拉伸线
        [self clearLine];
    }
}

#pragma mark 清除拉伸线
- (void)clearLine
{
    _beginPoint = CGPointZero;
    _movePoint = CGPointZero;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    // 绘制拉伸线路
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, _beginPoint.x, _beginPoint.y);
    CGContextAddLineToPoint(context, _movePoint.x, _movePoint.y);
    
    CGContextSetLineWidth(context, 5.0f);
    CGFloat length[] = {15.0, 5.0};
    CGContextSetLineDash(context, 0.0, length, 2);
    [[UIColor blackColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
