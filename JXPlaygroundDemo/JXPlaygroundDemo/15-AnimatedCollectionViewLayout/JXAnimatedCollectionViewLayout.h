//
//  JXAnimatedCollectionViewLayout.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLayoutAttributesAnimator.h"

@interface JXAnimatedCollectionViewLayout : UICollectionViewFlowLayout

@property(nonatomic, weak) id<JXLayoutAttributesAnimator> animator;

@end
