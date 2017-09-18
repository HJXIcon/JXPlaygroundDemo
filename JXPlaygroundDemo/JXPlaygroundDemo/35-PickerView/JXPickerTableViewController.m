//
//  JXPickerTableViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/18.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPickerTableViewController.h"
#import "JXDatePickerView.h"

@interface JXPickerTableViewController ()

@property(nonatomic, strong) NSArray <NSString *>*titlesArray;
@end

@implementation JXPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titlesArray = @[
                     @"datePicker"
                     ];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self showDatePickerView];
            break;
            
        default:
            break;
    }
    
    
}


- (void)showDatePickerView{
    JXDatePickerView *datePicker = [JXDatePickerView datePickerViewWithCompleteBlock:^(NSDate *date) {
        
    }];
    
    [datePicker show];
}

@end
