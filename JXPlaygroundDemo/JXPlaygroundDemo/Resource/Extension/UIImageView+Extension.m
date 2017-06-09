//
//  UIImageView+Extension.m
//  FishingWorld
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 zhuya. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}
@end
