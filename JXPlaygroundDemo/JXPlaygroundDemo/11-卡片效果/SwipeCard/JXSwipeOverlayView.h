//
//  JXSwipeOverlayView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , JXSwipeOverlayViewMode) {
    JXSwipeOverlayViewModeLeft,
    JXSwipeOverlayViewModeRight
};

@interface JXSwipeOverlayView : UIView

@property (nonatomic) JXSwipeOverlayViewMode mode;
@property (nonatomic, strong) UIImageView *imageView;

@end
