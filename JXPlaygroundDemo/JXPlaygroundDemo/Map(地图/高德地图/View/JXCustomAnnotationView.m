//
//  JXCustomAnnotationView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCustomAnnotationView.h"


#define kCalloutWidth       200.0
#define kCalloutHeight      70.0


@interface JXCustomAnnotationView ()

@property (nonatomic, strong, readwrite) JXCustomCalloutView *calloutView;

@end

@implementation JXCustomAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[JXCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"11"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}



@end
