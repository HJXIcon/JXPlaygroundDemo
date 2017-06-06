//
//  JXSwipeAbleSwipeOptions.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXSwipeAbleSwipeOptions.h"

@implementation JXSwipeAbleSwipeOptions
- (instancetype)initWithLocation:(CGPoint)location direction:(CGVector)direction {
    self = [super init];
    if (self) {
        self.location = location;
        self.direction = direction;
    }
    return self;
}

@end
