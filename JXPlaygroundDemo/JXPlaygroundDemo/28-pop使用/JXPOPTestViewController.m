//
//  JXPOPTestViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPOPTestViewController.h"
#import <pop/POP.h>

@interface JXPOPTestViewController ()

@end

@implementation JXPOPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    POPSpringAnimation *animation = [POPSpringAnimation animation];
    
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:100];
    animation.dynamicsMass = 5;
    
    [self.view.layer pop_addAnimation:animation forKey:@"myKey"];
}



@end
