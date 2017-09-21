//
//  JXTransitionAnimationViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXTransitionAnimationViewController.h"

@interface JXTransitionAnimationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JXTransitionAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.userInteractionEnabled = YES;
    
    //添加手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:rightSwipe];

}

static int _imageIndex = 1;
- (void)swipe:(UISwipeGestureRecognizer *)swipe {

    //转场代码与转场动画必须得在同一个方法当中.
    NSString *dir = nil;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        _imageIndex++;
        if (_imageIndex > 4) {
            _imageIndex = 1;
        }
        NSString *imageName = [NSString stringWithFormat:@"%d",_imageIndex];
        self.imageView.image = [UIImage imageNamed:imageName];
        
        dir = @"fromRight";
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        
        _imageIndex--;
        if (_imageIndex < 1) {
            _imageIndex = 4;
        }
        NSString *imageName = [NSString stringWithFormat:@"%d",_imageIndex];
        self.imageView.image = [UIImage imageNamed:imageName];
        
        dir = @"fromLeft";
    }
    
    
    //添加动画
    CATransition *anim = [CATransition animation];
    //设置转场类型
    anim.type = @"cube";
    //设置转场的方向
    anim.subtype = dir;
    
    anim.duration = 0.5;
    //动画从哪个点开始
    //    anim.startProgress = 0.2;
    //    anim.endProgress = 0.3;
    
    
    [self.imageView.layer addAnimation:anim forKey:nil];
    
  
    
}

@end
