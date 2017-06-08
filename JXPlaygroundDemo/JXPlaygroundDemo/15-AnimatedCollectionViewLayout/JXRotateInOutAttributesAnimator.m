//
//  JXRotateInOutAttributesAnimator.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXRotateInOutAttributesAnimator.h"

@implementation JXRotateInOutAttributesAnimator

- (instancetype)init{
    if (self = [super init]) {
        self.minAlpha = 0;
        self.maxRotate = M_PI / 4 / 4 / 3;
    }
    return self;
}


- (void)animate:(UICollectionView *)collectionView WithAttributes:(JXAnimatedCollectionViewLayoutAttributes *)attributes{
    
    CGFloat position = attributes.middleOffset;
    
    if (abs(position) >= 1) {
        attributes.transform = CGAffineTransformIdentity;
        attributes.alpha = 1.0;
        
    } else {
        CGFloat rotateFactor = self.maxRotate * position;
        attributes.zIndex = attributes.indexPath.row;
        attributes.alpha = 1.0 - abs(position) + self.minAlpha;
        
        attributes.transform = CGAffineTransformMakeRotation(rotateFactor);
    }
}

@end
