//
//  JXCustomAnnotationView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "JXCustomCalloutView.h"
/**
 自定义AnnotationView
 */
@interface JXCustomAnnotationView : MAAnnotationView


@property (nonatomic, readonly) JXCustomCalloutView *calloutView;

@end

