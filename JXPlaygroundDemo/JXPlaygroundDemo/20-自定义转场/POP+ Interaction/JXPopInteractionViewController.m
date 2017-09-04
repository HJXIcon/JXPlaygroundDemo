//
//  JXPopInteractionViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/4.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopInteractionViewController.h"
#import "JXPopInteraction.h"
#import "JXPopInteractionAnimation.h"
#import "JXPopInteractionDismissViewController.h"


@interface JXPopInteractionViewController ()<UIViewControllerTransitioningDelegate>
// 动画控制器
@property (nonatomic, strong)id<UIViewControllerAnimatedTransitioning> animationController;
// 交互控制器
@property (nonatomic, strong)JXPopInteraction *interactiveTransition;

@end

@implementation JXPopInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"带交互的POP";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 200, 30);
    button.center = self.view.center;
    [button setTitle:@"present view controller" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 初始化动画控制器
    _animationController = [[JXPopInteractionAnimation alloc]init];
    // 初始化交互控制器
    _interactiveTransition = [[JXPopInteraction alloc]init];
}


- (void)buttonClicked {
    JXPopInteractionDismissViewController *presentedVC = [[JXPopInteractionDismissViewController alloc]init];
    // 设置 presented view controller 的转场代理
    presentedVC.transitioningDelegate = self;
    // 添加交互
    [_interactiveTransition prepareForViewController:presentedVC];
    [self presentViewController:presentedVC animated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitioningDelegate
// 返回 present 动画控制器
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animationController;
}

// 返回 dismiss 动画控制器
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _animationController;
}




// 返回 dismiss 的交互控制器
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _interactiveTransition.isInteracting ? _interactiveTransition : nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _interactiveTransition.isInteracting ? _interactiveTransition : nil;
}

@end
