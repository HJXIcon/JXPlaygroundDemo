//
//  UIImageView+Extension.h
//  FishingWorld
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 zhuya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

/**
 *imageview重写
 */
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color;

@end
