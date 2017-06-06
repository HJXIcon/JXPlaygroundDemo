//
//  JXSwipeCardView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSwipeOverlayView.h"

@class JXSwipeCardView;
@protocol JXSwipeCardViewDelegate <NSObject>

-(void)cardSwipedLeft:(JXSwipeCardView *)card;
-(void)cardSwipedRight:(JXSwipeCardView *)card;

@end


@interface JXSwipeCardView : UIView


@property (nonatomic, weak) id <JXSwipeCardViewDelegate> delegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,assign) CGPoint originalPoint;
@property (nonatomic,strong) JXSwipeOverlayView *overlayView;
@property (nonatomic,strong) UILabel *information; // 卡片描述文字

- (void)leftClickAction;
- (void)rightClickAction;

@end
