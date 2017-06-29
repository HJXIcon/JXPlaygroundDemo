//
//  JXPasswordStrengthIndicatorView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PasswordStrengthIndicatorViewStatus) {
    PasswordStrengthIndicatorViewStatusNone,
    PasswordStrengthIndicatorViewStatusWeak,
    PasswordStrengthIndicatorViewStatusFair,
    PasswordStrengthIndicatorViewStatusStrong
};


@interface JXPasswordStrengthIndicatorView : UIView

@property(nonatomic) PasswordStrengthIndicatorViewStatus status;

@end
