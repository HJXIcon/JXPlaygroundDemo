//
//  JXTablePlaceHolderViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/7/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXTablePlaceHolderViewController.h"
#import "UITableView+placeholder.h"
#import "KKTableViewNoDataView.h"

@interface JXTablePlaceHolderViewController ()
@property (nonatomic, assign) BOOL flag;
@end

@implementation JXTablePlaceHolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.flag = !weakself.flag;
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
        });
        
    }];
    
    
    self.tableView.placeHolderView = [[KKTableViewNoDataView alloc] initWithFrame:self.view.bounds image:[UIImage imageNamed:@"no_data"] viewClick:^{
        
        [weakself.tableView.mj_header beginRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_flag) {
        return 0;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}


@end
