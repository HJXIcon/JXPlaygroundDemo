//
//  JXPaperViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPaperViewController.h"
#import "JXPaperButton.h"
#import <pop/POP.h>

@interface JXPaperViewController ()
@property(nonatomic) UILabel *titleLabel;

@end

@implementation JXPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarButton];
    [self addTitleLabel];
}

- (void)addBarButton
{
    JXPaperButton *button = [JXPaperButton button];
    [button addTarget:self action:@selector(animateTitleLabel:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor redColor];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)addTitleLabel
{
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:26.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = kRandomColorKRGBColor;
    [self setTitleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleLabel];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[_titleLabel]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-(80)-[_titleLabel]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_titleLabel)]];
}

- (void)animateTitleLabel:(id)sender
{
    CGFloat toValue = CGRectGetMidX(self.view.bounds);
    
    POPSpringAnimation *onscreenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    onscreenAnimation.toValue = @(toValue);
    onscreenAnimation.springBounciness = 10.f;
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    offscreenAnimation.toValue = @(-toValue);
    offscreenAnimation.duration = 0.2f;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self setTitleLabel];
        [self.titleLabel.layer pop_addAnimation:onscreenAnimation forKey:@"onscreenAnimation"];
    }];
    [self.titleLabel.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
}

- (void)setTitleLabel
{
    NSString *title = @"List";
    if ([self.titleLabel.text isEqualToString:title]) {
        title = @"Menu";
    }
    self.titleLabel.text = title;
}


@end
