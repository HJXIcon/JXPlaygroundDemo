//
//  ViewController.m
//  VFLDemo
//
//  Created by HJXICon on 2018/2/12.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "VFLViewController.h"

@interface VFLViewController ()

@end

@implementation VFLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button1 = [[UIButton alloc] init];
    button1.backgroundColor = [UIColor orangeColor];
    [button1 setTitle:@"ceshi" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *view1 = [[UIButton alloc] init];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    UIButton *view2 = [[UIButton alloc] init];
    view2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view2];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"leaves.png"];
    [self.view addSubview:imageView];
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button2];
    
    button1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    button2.translatesAutoresizingMaskIntoConstraints = NO;
    
    //通过宏映射成字典参数
    NSDictionary *views = NSDictionaryOfVariableBindings(button1, view1, view2, imageView, button2);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button1(==100)]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[button1]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view1(view2)]-[view2]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1]-20-[view1]" options:0 metrics:nil views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(260)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button2]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view1]-(==tpadding)-[imageView(400)]->=5-[button2]-(bpadding)-|" options:NSLayoutFormatAlignAllCenterX metrics:@{@"tpadding": @30, @"bpadding": @92} views:views]];
}


@end
