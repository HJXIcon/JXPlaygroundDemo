//
//  ButtonRepeatViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/8/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ButtonRepeatViewController.h"
#import "MyButton.h"
/**!
 参考原文
 http://www.mamicode.com/info-detail-1353412.html
 */

@interface ButtonRepeatViewController ()

@end

@implementation ButtonRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重复点击Button";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyButton *myButton = [MyButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(50, 60, 100, 30);
    [myButton setTitle:@"myButton" forState:UIControlStateNormal
     ];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 120, 100, 30);
    [button setTitle:@"UIButton" forState:UIControlStateNormal
     ];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


- (IBAction)myButtonClick:(MyButton *)sender {
    
    NSLog(@"MyButton被点击了 >>> %@", NSStringFromSelector(_cmd));
}

- (IBAction)buttonClick:(id)sender {
    NSLog(@"UIButton被点击了 >>> %@", NSStringFromSelector(_cmd));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
