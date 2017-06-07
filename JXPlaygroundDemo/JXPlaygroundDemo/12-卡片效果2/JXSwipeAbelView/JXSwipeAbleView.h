//
//  JXSwipeAbleView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSwipeAbleViewMovement.h"
#import "JXSwipeAbleSwipeOptions.h"

typedef NS_ENUM(NSUInteger, JXSwipeAbleViewDirection) {
    JXSwipeAbleViewDirectionNone = 0,
    JXSwipeAbleViewDirectionLeft = (1 << 0),
    JXSwipeAbleViewDirectionRight = (1 << 1),
    JXSwipeAbleViewDirectionHorizontal = JXSwipeAbleViewDirectionLeft |
    JXSwipeAbleViewDirectionRight,
    JXSwipeAbleViewDirectionUp = (1 << 2),
    JXSwipeAbleViewDirectionDown = (1 << 3),
    JXSwipeAbleViewDirectionVertical = JXSwipeAbleViewDirectionUp | JXSwipeAbleViewDirectionDown,
    JXSwipeAbleViewDirectionAll = JXSwipeAbleViewDirectionHorizontal |JXSwipeAbleViewDirectionVertical,
};
    


@class JXSwipeAbleView;

@protocol JXSwipeAbleViewAnimator <NSObject>

@required
- (void)animateView:(UIView *)view
              index:(NSUInteger)index
              views:(NSArray<UIView *> *)views
      swipeableView:(JXSwipeAbleView *)swipeableView;

@end


@protocol JXSwipeAbleViewDirectionInterpretor <NSObject>

@required
- (JXSwipeAbleSwipeOptions *)interpretDirection:(JXSwipeAbleViewDirection)direction
                                               view:(UIView *)view
                                              index:(NSUInteger)index
                                              views:(NSArray<UIView *> *)views
                                      swipeableView:(JXSwipeAbleView *)swipeableView;

@end

@protocol JXSwipeAbleViewSwipingDeterminator <NSObject>

@required
- (BOOL)shouldSwipeView:(UIView *)view
               movement:(JXSwipeAbleViewMovement *)movement
          swipeableView:(JXSwipeAbleView *)swipeableView;

@end

/// Delegate
@protocol JXSwipeAbleViewDelegate <NSObject>
@optional

// 滑动
- (void)swipeableView:(JXSwipeAbleView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(JXSwipeAbleViewDirection)direction;

// 取消
- (void)swipeableView:(JXSwipeAbleView *)swipeableView didCancelSwipe:(UIView *)view;

/**
 开始滑动
 @param location 位置
 */
- (void)swipeableView:(JXSwipeAbleView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location;

// 滑动到那个位置
- (void)swipeableView:(JXSwipeAbleView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation;

// 结束
- (void)swipeableView:(JXSwipeAbleView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location;

@end

// DataSource
@protocol JXSwipeAbleViewDataSource <NSObject>

@required
- (UIView *)nextViewForSwipeableView:(JXSwipeAbleView *)swipeableView;

@optional
- (UIView *)previousViewForSwipeableView:(JXSwipeAbleView *)swipeableView;

@end



@interface JXSwipeAbleView : UIView


// data source
@property (nonatomic, weak)  id<JXSwipeAbleViewDataSource> dataSource;

@property (nonatomic) NSUInteger numberOfActiveViews;

// delegate
@property (nonatomic, weak)  id<JXSwipeAbleViewDelegate> delegate;

// history
@property (nonatomic, readonly) NSArray<UIView *> *history;
@property (nonatomic) NSUInteger numberOfHistoryItem;

// Customization
@property (nonatomic, strong) id<JXSwipeAbleViewAnimator> viewAnimator;

@property (nonatomic, strong) id<JXSwipeAbleViewDirectionInterpretor> directionInterpretor;
@property (nonatomic, strong) id<JXSwipeAbleViewSwipingDeterminator> swipingDeterminator;

@property (nonatomic) CGFloat minTranslationInPercent;
@property (nonatomic) CGFloat minVelocityInPointPerSecond;
@property (nonatomic) JXSwipeAbleViewDirection allowedDirection;

- (UIView *)topView;

- (NSArray<UIView *> *)activeViews;

- (void)loadViewsIfNeeded;
// 倒回
- (void)rewind;

- (void)discardAllViews;

- (void)swipeTopViewToLeft;

- (void)swipeTopViewToRight;

- (void)swipeTopViewToUp;

- (void)swipeTopViewToDown;

- (void)swipeTopViewInDirection:(JXSwipeAbleViewDirection)direction;

- (void)swipeTopViewFromPoint:(CGPoint)point inDirection:(CGVector)directionVector;



@end
