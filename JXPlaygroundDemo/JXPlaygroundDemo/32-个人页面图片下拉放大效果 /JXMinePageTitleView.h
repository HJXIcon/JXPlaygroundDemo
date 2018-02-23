//
//  JXMinePageTitleView.h
//  JXPlaygroundDemo
//
//  Created by HJXICon on 2018/2/23.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXMinePageTitleView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) void (^buttonSelected)(NSInteger index);

@end
