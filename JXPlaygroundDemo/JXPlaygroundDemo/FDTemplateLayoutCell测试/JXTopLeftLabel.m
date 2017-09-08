//
//  JXTopLeftLabel.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/8.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXTopLeftLabel.h"


@implementation JXTopLeftLabel

- (id)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}




@end
