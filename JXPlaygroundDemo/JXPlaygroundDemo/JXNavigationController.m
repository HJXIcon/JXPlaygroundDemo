//
//  JXNavigationController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXNavigationController.h"

@interface JXNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) id interactivePopGesDelegate;
@end

@implementation JXNavigationController

/**
 *  当前类被加载到内存当中调用
 */
//+ (void)load {
//
//    //获取整个应用程序下的导航条
//    //UINavigationBar *bar = [UINavigationBar appearance];
//
//    //要获取哪个类下的导航条
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XMGNavigationController class]]];
//
//
//
//    //设置导航条背景,如果设置了导航条背景图片,那么它所在的控制器的View它的y值为64,如果没有设背景Y = 0;
//    [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
//
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
//
//    //设置文字属性
//    [bar setTitleTextAttributes:dict];
//
//    NSLog(@"%s",__func__);
//}

/**
 *  当前类或者它的子类,第一次使用的时候调用
 */
+(void)initialize {
    
    if (self == [JXNavigationController class]) {
        //要获取哪个类下的导航条
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[JXNavigationController class]]];
        
        
        
        //设置导航条背景,如果设置了导航条背景图片,那么它所在的控制器的View它的y值为64,如果没有设背景Y = 0;
        [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
        
        [bar setTintColor:[UIColor whiteColor]];
        
        //设置文字属性
        [bar setTitleTextAttributes:dict];
        
        
        UIBarButtonItem *item = [UIBarButtonItem appearance];
        [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //NSLog(@"%s",__func__);
    
    //当发生侧滑返回时, 会调用_UINavigationInteractiveTransition对象的handleNavigationTransition:方法
    //NSLog(@"%@",self.interactivePopGestureRecognizer);
    
    
    //self.interactivePopGestureRecognizer.delegate =  _UINavigationInteractiveTransition
    //NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
    //self.interactivePopGesDelegate = self.interactivePopGestureRecognizer.delegate;
    
    //self.delegate = self;
    
    
    //添加手势
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    
    //设置手势的代理
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}



-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //如果是根控制器,就不它调用手势方法
    //    if (self.childViewControllers.count == 1) {
    //        return NO;
    //    }else {
    //        return YES;
    //    }
    //return  self.childViewControllers.count == 1 ? NO : YES;
    
    return self.childViewControllers.count != 1;
    
}



//在返回的时候,判断当前的控制器是否为根控制器,如果是根控制器,把代理设置回去,

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    NSLog(@"%ld",self.childViewControllers.count);
//    if (self.childViewControllers.count == 2) {
//        self.interactivePopGestureRecognizer.delegate = self.interactivePopGesDelegate;
//    }
//    return [super popViewControllerAnimated:animated];
//}


//当导航控制器里面的View完全显示的时候调用.
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //在返回的时候,判断当前的控制器是否为根控制器,如果是根控制器,把代理设置回去,
    if(self.childViewControllers.count == 1) {
        self.interactivePopGestureRecognizer.delegate = self.interactivePopGesDelegate;
    }
    
}



//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    //根控制器不需要设置返回
//    if(self.childViewControllers.count != 0){
//        self.interactivePopGestureRecognizer.delegate = nil;
//        //设置返回图片
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderImageName:@"NavBack"] style:0 target:self action:@selector(back)];
//    }
//
//
//    [super pushViewController:viewController animated:animated];

//}

/**
 *  返回上一级
 */
- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
