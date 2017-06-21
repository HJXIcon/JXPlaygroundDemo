//
//  JXPopupViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopupViewController.h"
#import "JXPopupView.h"
#import "JXPopupInnerView.h"


@interface JXPopupViewController ()

@end

@implementation JXPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"26-弹出视图";
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    JXPopupInnerView *view = [JXPopupInnerView defaultPopupView];
    view.parentVC = self;
    view.selIndex = 3;
    
    [view setSelectCompletion:^(NSString *content, NSInteger index){
        
        NSLog(@"content == %@ index == %ld",content,index);
    }];
    
    JXPopupViewAnimationSlide *animation = [[JXPopupViewAnimationSlide alloc]init];
    animation.type = JXPopupViewAnimationSlideTypeBottomBottom;
    [self jx_presentPopupView:view animation:animation dismissed:^{
        NSLog(@"动画结束");
    }];
}
    


@end
