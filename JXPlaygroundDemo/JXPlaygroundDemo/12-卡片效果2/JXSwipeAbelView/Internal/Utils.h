//
//  Utils.h
//  JXSwipeAbleViewDemo
//
//  Created by Zhixuan Lai on 10/25/15.
//  Copyright © 2015 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXSwipeAbleView.h"

CGVector CGVectorFromCGPoint(CGPoint point);

CGFloat CGPointMagnitude(CGPoint point);

CGPoint CGPointNormalized(CGPoint point);

CGPoint CGPointMultiply(CGPoint point, CGFloat factor);

JXSwipeAbleViewDirection JXSwipeAbleViewDirectionFromVector(CGVector directionVector);

JXSwipeAbleViewDirection JXSwipeAbleViewDirectionFromPoint(CGPoint point);

@interface Utils : NSObject

@end
