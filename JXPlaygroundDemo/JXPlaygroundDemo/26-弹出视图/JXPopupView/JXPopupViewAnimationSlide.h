//
//  JXPopupViewAnimationSlide.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+JXPopupViewController.h"

typedef NS_ENUM(NSUInteger, JXPopupViewAnimationSlideType) {
    JXPopupViewAnimationSlideTypeBottomTop,
    JXPopupViewAnimationSlideTypeBottomBottom,
    JXPopupViewAnimationSlideTypeTopTop,
    JXPopupViewAnimationSlideTypeTopBottom,
    JXPopupViewAnimationSlideTypeLeftLeft,
    JXPopupViewAnimationSlideTypeLeftRight,
    JXPopupViewAnimationSlideTypeRightLeft,
    JXPopupViewAnimationSlideTypeRightRight,
};


@interface JXPopupViewAnimationSlide : NSObject<JXPopupAnimation>
@property (nonatomic,assign)JXPopupViewAnimationSlideType type;


@end
