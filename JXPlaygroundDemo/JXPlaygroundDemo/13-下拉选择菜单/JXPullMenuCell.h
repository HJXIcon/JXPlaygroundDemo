//
//  JXPullMenuCell.h
//  FishingWorld
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPullMenuModel;
@interface JXPullMenuCell : UITableViewCell

/** model*/
@property (nonatomic, strong)JXPullMenuModel *model;
+ (instancetype )cellOfCellConfigWithTableView:(UITableView *)tableView;
@end
