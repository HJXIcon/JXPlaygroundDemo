//
//  JXWaveProgressViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXWaveProgressViewController.h"
#import "JXWaveProgressView.h"

@interface JXWaveProgressViewController ()

@end

@implementation JXWaveProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"JXWaveProgressView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat WH = 300;
    JXWaveProgressView *progressView = [[JXWaveProgressView alloc]initWithFrame:CGRectMake((kScreenW - WH) / 2, 100, WH, WH)];
    progressView.percent = 0.6;
    progressView.showBgLineView = YES;
    progressView.waterBgColor = [UIColor clearColor];
    progressView.title = @"不适合钓鱼";
    [self.view addSubview:progressView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
