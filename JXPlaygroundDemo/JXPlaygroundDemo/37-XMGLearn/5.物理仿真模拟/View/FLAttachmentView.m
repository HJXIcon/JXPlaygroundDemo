//
//  FLAttachmentView.m
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLAttachmentView.h"

@interface FLAttachmentView ()
{
    UIImageView          *_imageView;
}
@end

@implementation FLAttachmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. 添加拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [self addGestureRecognizer:pan];
        
        // 2. 添加附着行为
        UIOffset offset = UIOffsetMake(-25, -25);
        _attachment = [[UIAttachmentBehavior alloc] initWithItem:self.box offsetFromCenter:offset attachedToAnchor:CGPointMake(self.box.center.x, self.box.center.y - 100)];
        
        [self.animator addBehavior:_attachment];
        
        // 3. 添加box内部锚点图像
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AttachmentPoint_Mask"]];
        imageView.center = CGPointMake(self.box.bounds.size.width / 2 + offset.horizontal, self.box.bounds.size.height / 2 + offset.vertical);
        
        [self.box addSubview:imageView];
        _imageView = imageView;
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateChanged == gesture.state) {
        
        _attachment.anchorPoint = [gesture locationInView:self];
        
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint p = [self convertPoint:_imageView.center fromView:self.box];
    CGContextMoveToPoint(context, p.x, p.y);
    CGContextAddLineToPoint(context, _attachment.anchorPoint.x, _attachment.anchorPoint.y);
    
    CGContextSetLineWidth(context, 5.0f);
    CGFloat length[] = {5.0, 5.0};
    CGContextSetLineDash(context, 0.0, length, 2);
    [[UIColor blackColor] set];
    
    CGContextDrawPath(context, kCGPathStroke);
}


@end
