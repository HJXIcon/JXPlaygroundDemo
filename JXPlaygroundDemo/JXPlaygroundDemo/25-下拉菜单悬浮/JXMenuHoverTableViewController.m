//
//  JXMenuHoverTableViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/19.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXMenuHoverTableViewController.h"
#import <DOPDropDownMenu-Enhanced/DOPDropDownMenu.h>



@interface JXMenuHoverTableViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>

@property(nonatomic, strong) DOPDropDownMenu *dropDownMenu;


@end

@implementation JXMenuHoverTableViewController
- (DOPDropDownMenu *)dropDownMenu{
    if (_dropDownMenu == nil) {
        _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        _dropDownMenu.dataSource = self;
        _dropDownMenu.delegate = self;
        _dropDownMenu.backgroundColor = [UIColor redColor];
    }
    return _dropDownMenu;
}


// 继承UITableViewController,更改tableview样式
- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    /**!
     把 UITableView 的 style 属性设置为 Plain ，这个tableview的section header在滚动时会默认悬停在界面顶端。
     */
    return [super initWithStyle:UITableViewStylePlain];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld - row:%ld",indexPath.section,indexPath.row];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.dropDownMenu;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 44 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}




#pragma mark - DOPDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 3;
}

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    return 3;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    return @"每行title";
}

@end
