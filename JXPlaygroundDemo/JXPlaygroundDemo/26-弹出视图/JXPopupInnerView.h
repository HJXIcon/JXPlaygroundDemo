//
//  JXPopupView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXPopupInnerViewSelectBlock)(NSString *, NSInteger);
@interface JXPopupInnerView : UIView


@property (nonatomic, weak)UIViewController *parentVC;
/*! 选中index */
@property(nonatomic, assign) NSInteger selIndex;

@property(nonatomic, copy) JXPopupInnerViewSelectBlock selectCompletion;

+ (instancetype)defaultPopupView;



@end
