//
//  JXXMGLearnTableViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXXMGLearnTableViewController.h"
#import "JXPersonDetailViewController.h"
#import "PersonDetailViewController.h"
#import "JXTransitionAnimationViewController.h"
#import "JXParticleEffectsViewController.h"
#import "JXCubeNavigationDemoViewController.h"
#import "JXDynamicAnimatorJXViewController.h"
#import "ANViewController.h"


@interface JXXMGLearnTableViewController ()

@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation JXXMGLearnTableViewController

- (NSArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = @[
                        @"1.个人详情页纯代码",
                        @"2.个人详情页sb",
                        @"3.转场动画",
                        @"4.粒子效果",
                        @"5.自定义push pop",
                        @"6.物理仿真",
                        @"7.tableView可实现屏幕滚动时的模糊效果"
                        ];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"各式demo";
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[JXPersonDetailViewController alloc]init];
            
            break;
            
        case 1:
            
            vc = [[UIStoryboard storyboardWithName:NSStringFromClass([PersonDetailViewController class]) bundle:nil] instantiateInitialViewController];
            break;
            
        case 2:
            
            vc = [[UIStoryboard storyboardWithName:NSStringFromClass([JXTransitionAnimationViewController class]) bundle:nil] instantiateInitialViewController];
            break;
            
        case 3:
            
            vc = [[UIStoryboard storyboardWithName:NSStringFromClass([JXParticleEffectsViewController class]) bundle:nil] instantiateInitialViewController];
            break;
            
        case 4:
            
            vc = [[JXCubeNavigationDemoViewController alloc]init];
            break;
            
        case 5:
            
            vc = [[JXDynamicAnimatorJXViewController alloc]init];
            break;
            
        case 6:
            vc = [[UIStoryboard storyboardWithName:NSStringFromClass([ANViewController class]) bundle:nil] instantiateInitialViewController];
            
            break;
            
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
