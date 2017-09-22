//
//  FLSpringView.m
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLSpringView.h"

@implementation FLSpringView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.attachment.damping = 1;
        self.attachment.frequency = 1;
        
        // 设置观察者，在手指离开以后继续画线
        [self.box addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        
        // 添加重力
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.box]];
        [self.attachment addChildBehavior:gravity];
        
        // 添加边界
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.box]];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        
        [self.attachment addChildBehavior:collision];
    }
    return self;
}

#pragma mark 画线
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

-(void)dealloc
{
    [self.box removeObserver:self forKeyPath:@"center"];
}

@end
