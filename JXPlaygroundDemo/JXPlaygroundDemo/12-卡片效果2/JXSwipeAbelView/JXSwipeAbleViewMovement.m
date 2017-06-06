//
//  JXSwipeAbleViewMovement.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXSwipeAbleViewMovement.h"

@implementation JXSwipeAbleViewMovement

- (instancetype)initWithLocation:(CGPoint)location
                      tranlation:(CGPoint)tranlation
                        velocity:(CGPoint)velocity {
    self = [super init];
    if (self) {
        self.location = location;
        self.translation = tranlation;
        self.velocity = velocity;
    }
    return self;
}


@end
