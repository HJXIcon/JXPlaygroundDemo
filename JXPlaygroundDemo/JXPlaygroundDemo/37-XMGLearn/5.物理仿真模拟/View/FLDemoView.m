//
//  FLDemoView.m
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLDemoView.h"

@implementation FLDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. 设置网格背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTile"]];
        
        // 2. 设置方块
        UIImageView *box = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Box1"]];
        box.center = self.center;
        _box = box;
        [self addSubview:box];
        
        // 3. 创建仿真
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
                
    }
    return self;
}


@end
