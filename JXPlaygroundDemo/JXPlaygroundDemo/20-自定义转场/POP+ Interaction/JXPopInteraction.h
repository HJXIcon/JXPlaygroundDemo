//
//  JXPopInteraction.h
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/4.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JXPopInteraction : UIPercentDrivenInteractiveTransition
// 标记是否是交互转场
@property (nonatomic, readonly, getter=isInteracting)BOOL interacting;
// 一些初始化工作
- (void)prepareForViewController:(UIViewController *)viewController;

@end
