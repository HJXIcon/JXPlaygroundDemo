//
//  SwipeCardViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "SwipeCardViewController.h"
#import "JXSwipeCardViewBackground.h"

@interface SwipeCardViewController ()

@end

@implementation SwipeCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"卡片效果";
    
    JXSwipeCardViewBackground *draggableBackground = [[JXSwipeCardViewBackground alloc]initWithFrame:self.view.frame];
    draggableBackground.exampleCardLabels = @[@"卡片1",@"卡片1",@"卡片1",@"卡片1",@"卡片1",@"卡片1",@"卡片1",@"卡片1"];
    [self.view addSubview:draggableBackground];
}



@end
