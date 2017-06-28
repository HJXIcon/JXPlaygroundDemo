//
//  JXAdaptationManager.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAdaptationManager.h"

/// 6P 宽高
#define DesignWidth  414
#define DesignHeight 736


@interface JXAdaptationManager ()
@property (nonatomic, assign) CGRect  windowRect;
@property (nonatomic, assign) CGFloat windowWidth;
@property (nonatomic, assign) CGFloat windowHeight;
@property (nonatomic, assign) CGFloat scaleValue;


@property(nonatomic, assign) BOOL isIPHONE6P;
@property (nonatomic, assign) CGFloat scaleRate;// 缩放比例  相对于iPhone6Plus的屏幕宽度

@end

@implementation JXAdaptationManager


+ (JXAdaptationManager *)manager
{
    
    static JXAdaptationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JXAdaptationManager alloc] init];
        [manager initData];
    });
    
    return manager;
}

- (void)initData
{
    _windowRect   = [UIScreen mainScreen].bounds;
    _windowWidth  = CGRectGetWidth(_windowRect);
    _windowHeight = CGRectGetHeight(_windowRect);
    _scaleValue   = [[UIScreen mainScreen] scale];
    _isIPHONE6P   = NO;
    
    if (_windowWidth - DesignWidth < 0.001) {
        _isIPHONE6P = YES;
        self.scaleRate = 1.0;
    }
    else
    {
        self.scaleRate = _windowWidth / (DesignWidth * 1.0);
    }
    
    self.fontSizeOffset = 0.0;
    if (!_isIPHONE6P) {
        if (self.scaleRate < 0.773) {  // iphone5(s) 320/414 < 0.773
            self.fontSizeOffset = - 1.0;
        }
        else if (self.scaleRate < 0.906) // iphone6(s) 375/414 < 0.906
        {
            self.fontSizeOffset = - 2.0;
        }
        
    }
}


#pragma mark - public Method
// Value
- (CGFloat)scaleForValue:(CGFloat)value
{
    if (_isIPHONE6P) {
        return value;
    }
    return value*_scaleRate;
}


// CGSize
- (CGSize)scaleCGSize:(CGSize)size
{
    size.width  = [self scaleForValue:size.width];
    size.height = [self scaleForValue:size.height];
    
    return size;
}

// CGPoint
- (CGPoint)scaleCGPoint:(CGPoint)point
{
    point.x = [self scaleForValue:point.x];
    point.y = [self scaleForValue:point.y];
    
    return point;
}


// CGRect
- (CGRect)scaleCGRect:(CGRect)rect
{
    rect.size   = [self scaleCGSize:rect.size];
    rect.origin = [self scaleCGPoint:rect.origin];
    
    return rect;
}



@end
