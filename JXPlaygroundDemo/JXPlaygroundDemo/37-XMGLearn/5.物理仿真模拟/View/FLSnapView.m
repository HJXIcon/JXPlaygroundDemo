//
//  FLSnapView.m
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLSnapView.h"

@implementation FLSnapView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 移除之前的仿真行为
    [self.animator removeAllBehaviors];
    
    CGPoint location = [touches.anyObject locationInView:self];
    
    // 添加行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.box snapToPoint:location];
        // 随机振幅
        snap.damping = arc4random_uniform(5) / 10.0 + 0.5;
    
    // 添加仿真行为
    [self.animator addBehavior:snap];
}

@end
