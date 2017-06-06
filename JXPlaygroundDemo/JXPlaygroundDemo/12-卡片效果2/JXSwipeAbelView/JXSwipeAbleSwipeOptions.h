//
//  JXSwipeAbleSwipeOptions.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXSwipeAbleSwipeOptions : NSObject
@property (nonatomic) CGPoint location;
@property (nonatomic) CGVector direction;  // 创建一个矢量

- (instancetype)initWithLocation:(CGPoint)location direction:(CGVector)direction;

@end
