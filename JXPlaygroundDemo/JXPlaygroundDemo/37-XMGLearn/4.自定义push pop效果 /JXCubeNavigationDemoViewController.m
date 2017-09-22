//
//  JXCubeNavigationDemoViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/22.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCubeNavigationDemoViewController.h"
#import "FlipSquaresNavigationController.h"
#import "ViewController.h"
#import "CubeNavigationController.h"
@interface JXCubeNavigationDemoViewController ()

@end

@implementation JXCubeNavigationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[FlipSquaresNavigationController alloc] initWithRootViewController:[[ViewController alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
