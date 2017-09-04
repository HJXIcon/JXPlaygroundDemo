//
//  JXTransitionTableViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXTransitionTableViewController.h"
#import "JXTransitionViewController.h"
#import "JXPopPresentViewController.h"
#import "JXPaperViewController.h"
#import "JXPasswordViewController.h"
#import "JXPopInteractionViewController.h"

@interface JXTransitionTableViewController ()
@property(nonatomic, strong) NSArray *datas;
@end

@implementation JXTransitionTableViewController

- (NSArray *)datas{
    if (_datas == nil) {
        _datas = @[
                   @"1 - 效果",
                   @"2 - POP - PresentModal",
                   @"3 - pop - paper",
                   @"4 - 密码强度指示",
                   @"5 - POP - 带交互的PresentModal"
                   ];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"转场动画";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[JXTransitionViewController alloc]init];
            break;
            
        case 1:
            vc = [[JXPopPresentViewController alloc]init];
            break;
            
        case 2:
            vc = [[JXPaperViewController alloc]init];
            break;
            
        case 3:
            vc = [[JXPasswordViewController alloc]init];
            break;
            
        case 4:
            vc = [[JXPopInteractionViewController alloc]init];
            break;
            
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
