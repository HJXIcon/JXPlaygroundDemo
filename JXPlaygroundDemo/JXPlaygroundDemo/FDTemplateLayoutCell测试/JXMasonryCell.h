//
//  JXMasonryCell.h
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDTModel;
@interface JXMasonryCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
-(void)fill:(FDTModel *)model;
@end
