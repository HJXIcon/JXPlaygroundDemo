//
//  JXPullMenuView.h
//  FishingWorld
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPullMenuModel.h"

typedef void(^SelectBlock)(JXPullMenuModel *model, NSInteger index);
typedef NS_ENUM(NSInteger, PullMenuStatus)
{
    PullMenuStatus_show = 0,
    PullMenuStatus_diss = 1
};

/**
 下拉选择View
 */
@interface JXPullMenuView : UIView



/**
 回调
 */
@property(nonatomic,copy)SelectBlock valueChangeBlock;
/** leftText*/
@property (nonatomic, strong)NSString *leftText;

/** 当前展示cell的下标*/
@property (nonatomic, assign)NSInteger seleIndex;

/**
 便利构建方法
 @param data 数据（字典数组）
 @param leftText 左边文字
 */
- (id)initWithFrame:(CGRect)frame Data:(NSArray *)data leftText:(NSString *)leftText;

@end
