//
//  JXAdvertiseViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/16.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAdvertiseViewController.h"
#import "AdvertiseHelper.h"

@interface JXAdvertiseViewController ()

@end

@implementation JXAdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"启动广告" forState:UIControlStateNormal];
    [btn setTitleColor:kRandomColorKRGBColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:btn];
    
}

- (void)btnAction{
    // TODO 请求广告接口 获取广告图片
    
    //现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    
    [AdvertiseHelper showAdvertiserView:imageArray];
}


@end
