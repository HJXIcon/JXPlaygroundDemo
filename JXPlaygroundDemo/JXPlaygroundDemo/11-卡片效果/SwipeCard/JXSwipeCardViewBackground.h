//
//  JXSwipeCardViewBackground.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSwipeCardView.h"

@interface JXSwipeCardViewBackground : UIView

/// 卡片文本数组
@property (strong, nonatomic)NSArray <NSString *>*exampleCardLabels;
/// 卡片View数组
@property (strong, nonatomic)NSMutableArray <JXSwipeCardView *>*allCards;

@end
