//
//  FlowLayoutTableViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "FlowLayoutTableViewController.h"
#import "JXCardView3DViewController.h"
#import "JXCardViewScaleLayoutViewController.h"

@interface FlowLayoutTableViewController ()

@property(nonatomic, strong) NSArray *datas;
@end

@implementation FlowLayoutTableViewController
- (NSArray *)datas{
    if (_datas  == nil) {
        _datas = @[
                   @"CardView3DLayout",
                   @"CardViewScaleLayout"
                   ];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自定义UICollectionViewFlowLayout集合";
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
            vc = [[JXCardView3DViewController alloc]init];
            break;
            
        case 1:
            vc = [[JXCardViewScaleLayoutViewController alloc]init];
            break;
            
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
