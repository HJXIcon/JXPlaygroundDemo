//
//  VFLViewController3.m
//  JXPlaygroundDemo
//
//  Created by HJXICon on 2018/2/12.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "VFLViewController3.h"

@interface VFLViewController3 ()
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong)  NSArray<NSLayoutConstraint *> *Vconst;
@property (nonatomic, strong)  NSArray<NSLayoutConstraint *> *Hconst;
@end

@implementation VFLViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViewStyle1];
    [self setupViewStyle2];
    [self setupViewStyle3];
    [self setupViewStyle4];
    [self setupViewStyle5];
}
- (void)setupViewStyle5{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [button setTitle:@"点我改变约束" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(button);
    NSArray *Hconst = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-10-|" options:0 metrics:nil views:views];
    [self.view addConstraints:Hconst];
    NSArray *Vconst = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-50-|" options:0 metrics:nil views:views];
    _Vconst = Vconst;
    _Hconst = Hconst;
    [self.view addConstraints:Vconst];
}

- (void)changeAction:(UIButton *)button{
    
    // 1.删除约束
    [self.view removeConstraints:_Vconst];
    [self.view removeConstraints:_Hconst];
    
     NSDictionary *views = NSDictionaryOfVariableBindings(button);
    // 2.添加新的约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-150-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-50-|" options:0 metrics:nil views:views]];
    
    [UIView animateWithDuration:2 animations:^{
        // 3.更新视图
        [self.view layoutIfNeeded];
    }];
    
   

}
- (void)setupViewStyle4{
    _mainLabel = [[UILabel alloc]init];
    _mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _mainLabel.textColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    _mainLabel.backgroundColor = [UIColor orangeColor];
    _mainLabel.text = @"标题";
    _mainLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_mainLabel];
    
    _subLabel = [[UILabel alloc]init];
    _subLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subLabel.textColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    _subLabel.font = [UIFont systemFontOfSize:15];
    _subLabel.backgroundColor = [UIColor purpleColor];
    _subLabel.numberOfLines = 0;
    [self.view addSubview:_subLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_mainLabel,_subLabel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_mainLabel]-0-[_subLabel]->=10-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_mainLabel]" options:0 metrics:nil views:views]];
    
    // 居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_subLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
    
    NSMutableString *subText = [NSMutableString string];
    int num = arc4random_uniform(16);
    for (int i = num; i > 0; i --) {
         subText = [NSMutableString stringWithString:[subText stringByAppendingFormat:@"副标题、"]];
    }
    _subLabel.text = subText;
}

- (void)setupViewStyle3{
    UIView *supview = [[UIView alloc]init];
    supview.translatesAutoresizingMaskIntoConstraints=NO;
    supview.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [self.view addSubview:supview];
    
    UIView *subView = [[UIView alloc]init];
    subView.translatesAutoresizingMaskIntoConstraints=NO;
    subView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [supview addSubview:subView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(supview,subView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[supview(200)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[supview(200)]-70-|" options:0 metrics:nil views:views]];
    
    [supview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subView(80)]" options:0 metrics:nil views:views]];
    
    [supview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subView(80)]" options:0 metrics:nil views:views]];
    
    
    // 居中
    [supview addConstraint:[NSLayoutConstraint constraintWithItem:supview
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:subView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [supview addConstraint:[NSLayoutConstraint constraintWithItem:supview
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:subView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];
}

- (void)setupViewStyle2{
    UIView *view0 = [[UIView alloc]init];
    view0.translatesAutoresizingMaskIntoConstraints=NO;
    view0.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [self.view addSubview:view0];
    
    UIView *view1 = [[UIView alloc]init];
    view1.translatesAutoresizingMaskIntoConstraints=NO;
    view1.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]init];
    view2.translatesAutoresizingMaskIntoConstraints=NO;
    view2.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc]init];
    view3.translatesAutoresizingMaskIntoConstraints=NO;
    view3.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [self.view addSubview:view3];
    
     NSDictionary *views = NSDictionaryOfVariableBindings(view0,view1,view2,view3);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[view0(view3)]-[view1(view3)]-[view2(view3)]-[view3]-10-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[view0(view3)][view1(view3)][view2(view3)][view3(60)]" options:0 metrics:nil views:views]];
    
}
- (void)setupViewStyle1{
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    
    UIView *orangeView = [[UIView alloc] init];
    orangeView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:orangeView];
    
    UIView *purpleView = [[UIView alloc] init];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    
    
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    orangeView.translatesAutoresizingMaskIntoConstraints = NO;
    purpleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //通过宏映射成字典参数
    NSDictionary *views = NSDictionaryOfVariableBindings(redView, blueView,orangeView,purpleView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[redView(blueView)]-20-[blueView]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[orangeView(200)]-0-[purpleView(80)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[redView(60)][blueView(redView)]-30-[orangeView(40)]-30-[purpleView(80)]" options:0 metrics:nil views:views]];
    
    // 居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:orangeView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
}



@end
