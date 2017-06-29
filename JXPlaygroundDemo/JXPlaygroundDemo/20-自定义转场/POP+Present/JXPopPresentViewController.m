//
//  JXPopPresentViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopPresentViewController.h"
#import "JXModalViewController.h"
#import "JXPresentingAnimator.h"
#import "JXDismissingAnimator.h"

@interface JXPopPresentViewController ()<UIViewControllerTransitioningDelegate>
@property(nonatomic, strong) UIButton *pushBtn;
@end

@implementation JXPopPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"POP-Present";
    
    _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    [_pushBtn addTarget:self action:@selector(presentAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_pushBtn setTitle:@"present" forState:UIControlStateNormal];
    [_pushBtn setTitleColor:kRandomColorKRGBColor forState:UIControlStateNormal];
    _pushBtn.frame = CGRectMake(100, 100, 60, 30);
    [self.view addSubview:_pushBtn];
}



- (void)presentAction{
    
    JXModalViewController *modalViewController = [JXModalViewController new];
    modalViewController.transitioningDelegate = self;
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController presentViewController:modalViewController
                                            animated:YES
                                          completion:NULL];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [JXPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [JXDismissingAnimator new];
}


@end
