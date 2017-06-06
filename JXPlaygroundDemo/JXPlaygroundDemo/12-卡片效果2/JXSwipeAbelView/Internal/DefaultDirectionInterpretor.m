//
//  DefaultDirectionInterpretor.m
//  JXSwipeAbleViewDemo
//
//  Created by Zhixuan Lai on 10/25/15.
//  Copyright © 2015 Zhixuan Lai. All rights reserved.
//

#import "DefaultDirectionInterpretor.h"

@implementation DefaultDirectionInterpretor

- (JXSwipeAbleSwipeOptions *)interpretDirection:(JXSwipeAbleViewDirection)direction
                                               view:(UIView *)view
                                              index:(NSUInteger)index
                                              views:(NSArray<UIView *> *)views
                                      swipeableView:(JXSwipeAbleView *)swipeableView {
    CGFloat programaticSwipeVelocity = 1000;
    CGPoint location = CGPointMake(view.center.x, view.center.y * 0.7);
    CGVector directionVector;
    switch (direction) {
    case JXSwipeAbleViewDirectionLeft:
        directionVector = CGVectorMake(-programaticSwipeVelocity, 0);
        break;
    case JXSwipeAbleViewDirectionRight:
        directionVector = CGVectorMake(programaticSwipeVelocity, 0);
        break;
    case JXSwipeAbleViewDirectionUp:
        directionVector = CGVectorMake(0, -programaticSwipeVelocity);
        break;
    case JXSwipeAbleViewDirectionDown:
        directionVector = CGVectorMake(0, programaticSwipeVelocity);
        break;
    default:
        directionVector = CGVectorMake(0, 0);
        break;
    }
    return
        [[JXSwipeAbleSwipeOptions alloc] initWithLocation:location direction:directionVector];
}

@end
