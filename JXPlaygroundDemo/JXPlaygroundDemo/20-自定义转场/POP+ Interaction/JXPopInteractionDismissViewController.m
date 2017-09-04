//
//  JXPopInteractionDismissViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/4.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopInteractionDismissViewController.h"

@interface JXPopInteractionDismissViewController ()

@end

@implementation JXPopInteractionDismissViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0, 0, 200, 30);
    button.center = self.view.center;
    [button setTitle:@"dismiss view controller" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
