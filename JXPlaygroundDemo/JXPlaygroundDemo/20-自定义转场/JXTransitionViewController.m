//
//  JXTransitionViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXTransitionViewController.h"
#import "JXPushTransition.h"
#import "JXTransitionViewController2.h"
#import "JXPopTransition.h"

@interface JXTransitionViewController ()<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong) UIButton *pushBtn;
@property(nonatomic, strong) JXPushTransition *pushTransition;
@end

@implementation JXTransitionViewController
/**!
 ViewController如何使用自定义转场动画
 1.在push的控制器设置navigationController的delegate为self
   self.navigationController.delegate = self;
 
 2.实现协议方法
 - (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
 animationControllerForOperation:(UINavigationControllerOperation)operation
 fromViewController:(UIViewController *)fromVC
 toViewController:(UIViewController *)toVC {
 if (operation == UINavigationControllerOperationPush) {
 LYPushTransition *push = [LYPushTransition new];
 return push;
 } else if (operation == UINavigationControllerOperationPop) {
 LYPopTransition *pop = [LYPopTransition new];
 return pop;
 }else {
 return nil;
 }
 }
 
 通过operation判断是push操作还是pop操作,然后然后对于的动画即可
 pop控制器不需要做任何操作
 如果使用push,则会发现NavigationBar没有变化,会一直处于那个地方,很丑...
 然而使用present就可以避免这种现象
 
 presentViewController
 设置presentViewController的ViewController的transitioningDelegate为self
 注意,如果是present的UINavigationController,则需要设置NavigationController的transitioningDelegate为self
 
 UIStoryboard *storyboard = [UIStoryboard     storyboardWithName:@"Main" bundle:nil];
 SecondViewController *secondVC = [storyboard instantiateViewControllerWithIdentifier:@"second"];
 secondVC.delegate = self;
 // present
UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:secondVC];
 
// 如果present的NavigationController则需要设置NavigationController的transitioningDelegate为self
navi.transitioningDelegate = self;
[self presentViewController:navi animated:YES completion:nil];
 
 
 实现transitioningDelegate协议方法
// prensent
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.push;
}
 
// dismiss
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.pop;
}


 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kRandomColorKRGBColor;
    
    _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    [_pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    
    [_pushBtn setTitle:@"push" forState:UIControlStateNormal];
    [_pushBtn setTitleColor:kRandomColorKRGBColor forState:UIControlStateNormal];
    _pushBtn.frame = CGRectMake(100, 100, 60, 30);
    [self.view addSubview:_pushBtn];
    
    
    // 1.
    self.navigationController.delegate = self;
}



- (void)push{
    
    [self.navigationController pushViewController:[[JXTransitionViewController2 alloc]init] animated:YES];
}



// 3
#pragma mark - UIViewControllerTransitioningDelegate
/** prensent */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [JXPushTransition new];
}
/** dismiss */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [JXPopTransition new];
}


#pragma mark - UINavigationControllerDelegate
//2.实现协议方法
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        JXPushTransition *push = [JXPushTransition new];
        return push;
    } else if (operation == UINavigationControllerOperationPop) {
        JXPopTransition *pop = [JXPopTransition new];
        return pop;
    }else {
        return nil;
    }
}


@end
