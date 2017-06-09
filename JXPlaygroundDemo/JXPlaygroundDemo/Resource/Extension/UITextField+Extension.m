//
//  UITextField+Extension.m
//  FishingWorld
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 zhuya. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

+ (instancetype)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];;
    textField.font = font;
    textField.textColor = [UIColor blackColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    return textField;
}

@end
