//
//  JXLayoutAttributesAnimator.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JXAnimatedCollectionViewLayoutAttributes.h"

@protocol JXLayoutAttributesAnimator <NSObject>


- (void)animate:(UICollectionView *)collectionView WithAttributes:(JXAnimatedCollectionViewLayoutAttributes *)attributes;
@end
