//
//  Utils.m
//  JXSwipeAbleViewDemo
//
//  Created by Zhixuan Lai on 10/25/15.
//  Copyright © 2015 Zhixuan Lai. All rights reserved.
//

#import "Utils.h"

CGVector CGVectorFromCGPoint(CGPoint point) { return CGVectorMake(point.x, point.y); }

CGFloat CGPointMagnitude(CGPoint point) { return sqrtf(powf(point.x, 2) + powf(point.y, 2)); }

CGPoint CGPointNormalized(CGPoint point) {
    CGFloat magnitude = CGPointMagnitude(point);
    return CGPointMake(point.x / magnitude, point.y / magnitude);
}

CGPoint CGPointMultiply(CGPoint point, CGFloat factor) {
    return CGPointMake(point.x * factor, point.y * factor);
}

JXSwipeAbleViewDirection JXSwipeAbleViewDirectionFromVector(CGVector directionVector) {
    JXSwipeAbleViewDirection direction = JXSwipeAbleViewDirectionNone;
    if (ABS(directionVector.dx) > ABS(directionVector.dy)) {
        if (directionVector.dx > 0) {
            direction = JXSwipeAbleViewDirectionRight;
        } else {
            direction = JXSwipeAbleViewDirectionLeft;
        }
    } else {
        if (directionVector.dy > 0) {
            direction = JXSwipeAbleViewDirectionDown;
        } else {
            direction = JXSwipeAbleViewDirectionUp;
        }
    }

    return direction;
}

JXSwipeAbleViewDirection JXSwipeAbleViewDirectionFromPoint(CGPoint point) {
    return JXSwipeAbleViewDirectionFromVector(CGVectorFromCGPoint(point));
}

@implementation Utils

@end
