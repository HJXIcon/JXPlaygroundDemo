//
//  JXSwipeOverlayView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXSwipeOverlayView.h"

@implementation JXSwipeOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noButton"]];
        [self addSubview:_imageView];
    }
    return self;
}

-(void)setMode:(JXSwipeOverlayViewMode)mode
{
    if (_mode == mode) {
        return;
    }
    
    _mode = mode;
    
    if(mode == JXSwipeOverlayViewModeLeft) {
        _imageView.image = [UIImage imageNamed:@"noButton"];
    } else {
        _imageView.image = [UIImage imageNamed:@"yesButton"];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(50, 50, 200, 200);
}
@end
