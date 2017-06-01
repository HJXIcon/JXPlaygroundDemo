//
//  JXBanTangHeaderView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 替换导航条View
 */
@interface JXBanTangHeaderView : UIView

@property (nonatomic, weak) UITableView *tableView;

@property(nonatomic,copy)NSMutableArray *tableViews;

@end
