//
//  JXRotateInOutAttributesAnimator.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXLayoutAttributesAnimator.h"

@interface JXRotateInOutAttributesAnimator : NSObject<JXLayoutAttributesAnimator>

@property(nonatomic, assign) CGFloat minAlpha;
@property(nonatomic, assign) CGFloat maxRotate;


@end
