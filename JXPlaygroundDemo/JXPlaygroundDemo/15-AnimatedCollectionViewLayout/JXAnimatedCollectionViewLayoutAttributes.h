//
//  JXAnimatedCollectionViewLayoutAttributes.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXAnimatedCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes


@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
// 开始的cell的 index.row
@property(nonatomic, assign) CGFloat startOffset;
// 当前显示的cell的 index.row
@property(nonatomic, assign) CGFloat middleOffset;
// 消失的cell的 index.row
@property(nonatomic, assign) CGFloat endOffset;


@end
