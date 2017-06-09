//
//  UISwitch+Expand.m
//  demo
//
//  Created by liuming on 16/6/22.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "UISwitch+Expand.h"

@interface UISwitch ()
@property(nonatomic, strong) UIColor *offTintColor;
@end
@implementation UISwitch (Expand)

- (UIColor *)offTintColor
{
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color == nil)
    {
        color = [UIColor whiteColor];
        [self setOffTintColor:color];
    }

    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOffTintColor:(UIColor *)offTintColor
{
    objc_setAssociatedObject(self, @selector(offTintColor), offTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self changeTinColorAndThumbTintColor];
}

- (void)changeTinColorAndThumbTintColor
{
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2.0;
    self.backgroundColor = self.offTintColor;
    self.tintColor = self.offTintColor;
}
@end
