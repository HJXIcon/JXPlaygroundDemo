//
//  FLDemoView.h
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLDemoView : UIView

// 方块视图
@property (weak, nonatomic) UIImageView *box;

// 仿真者
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end
