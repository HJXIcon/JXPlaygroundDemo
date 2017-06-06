//
//  JXSwipeCardViewBackground.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXSwipeCardViewBackground.h"

static  int const MAX_BUFFER_SIZE = 2;
static  float const CARD_HEIGHT = 386;
static  float const CARD_WIDTH = 290;

@interface JXSwipeCardViewBackground ()<JXSwipeCardViewDelegate>

@end
@implementation JXSwipeCardViewBackground{
    NSInteger cardsLoadedIndex; // 当前卡片Index
    NSMutableArray <JXSwipeCardView *>*loadedCards; // 加载的图片
    UIButton *menuButton;
    UIButton *messageButton;
    UIButton *checkButton;
    UIButton *xButton;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
        _exampleCardLabels = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil];
        loadedCards = [[NSMutableArray alloc] init];
        _allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self loadCards];
    }
    return self;
}


-(void)loadCards
{
    if([_exampleCardLabels count] > 0) {
        // 1.是否大于二
        // if count == 3
        NSInteger numLoadedCardsCap = (([_exampleCardLabels count] > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE:[_exampleCardLabels count]);
        
        // numLoadedCardsCap == 2
        // 2.添加
        for (int i = 0; i<[_exampleCardLabels count]; i++) {
            JXSwipeCardView *newCard = [self createDraggableViewWithDataAtIndex:i];
            [_allCards addObject:newCard];
            
            if (i < numLoadedCardsCap) {
                // 加载的图片（不大于2张）
                [loadedCards addObject:newCard];
            }
        }
        
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i > 0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex ++;
        }
    }
}

/// 创建一个swipeView
- (JXSwipeCardView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    JXSwipeCardView *swipeView = [[JXSwipeCardView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    swipeView.information.text = [_exampleCardLabels objectAtIndex:index];
    swipeView.delegate = self;
    return swipeView;
}


-(void)setupView
{
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuButton];
    [self addSubview:messageButton];
    [self addSubview:xButton];
    [self addSubview:checkButton];
}

#pragma mark - Actions
-(void)swipeRight
{
    JXSwipeCardView *swipeView = [loadedCards firstObject];
    swipeView.overlayView.mode = JXSwipeOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        swipeView.overlayView.alpha = 1;
    }];
    [swipeView rightClickAction];
}

-(void)swipeLeft
{
    JXSwipeCardView *swipeView = [loadedCards firstObject];
    swipeView.overlayView.mode = JXSwipeOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        swipeView.overlayView.alpha = 1;
    }];
    [swipeView leftClickAction];
}



#pragma mark - JXSwipeCardViewDelegate
-(void)cardSwipedLeft:(JXSwipeCardView *)card;
{
    [loadedCards removeObjectAtIndex:0];
    if (cardsLoadedIndex < [_allCards count]) { 
        [loadedCards addObject:[_allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex ++;
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE - 1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE - 2)]];
    }
}


-(void)cardSwipedRight:(JXSwipeCardView *)card
{
    [loadedCards removeObjectAtIndex:0];
    if (cardsLoadedIndex < [_allCards count]) {
        [loadedCards addObject:[_allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex ++;
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE - 1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE - 2)]];
    }
    
}


@end
