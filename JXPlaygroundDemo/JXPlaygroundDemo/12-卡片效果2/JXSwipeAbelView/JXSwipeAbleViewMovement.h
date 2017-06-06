//
//  JXSwipeAbleViewMovement.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXSwipeAbleViewMovement : NSObject

@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint translation;
@property (nonatomic) CGPoint velocity;

- (instancetype)initWithLocation:(CGPoint)location
                      tranlation:(CGPoint)tranlation
                        velocity:(CGPoint)velocity;


@end
