//
//  JXDynamicAnimatorJXViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/22.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXDynamicAnimatorJXViewController.h"
#import "FLDemoViewController.h"

@interface JXDynamicAnimatorJXViewController ()

@property(nonatomic, strong) NSArray *datas;
@end

@implementation JXDynamicAnimatorJXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物理仿真";
    
    self.datas = @[
                   @"吸附效果",
                   @"推动效果",
                   @"刚性附着效果",
                   @"弹性附着效果"
                   ];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLDemoViewController *demoVC = [[FLDemoViewController alloc] init];
    demoVC.title = self.datas[indexPath.row];
    demoVC.type = indexPath.row;
    
    [self.navigationController pushViewController:demoVC animated:YES];
}

@end
