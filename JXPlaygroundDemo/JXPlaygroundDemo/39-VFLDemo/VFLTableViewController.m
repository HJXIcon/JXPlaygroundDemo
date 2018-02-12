//
//  VFLTableViewController.m
//  JXPlaygroundDemo
//
//  Created by HJXICon on 2018/2/12.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "VFLTableViewController.h"
#import "VFLViewController.h"
#import "VFLViewController2.h"

@interface VFLTableViewController ()
@property (nonatomic, strong) NSArray *datas;
@end

@implementation VFLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[@"Demo1",@"Demo2"];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [[VFLViewController alloc]init];
            break;
            
        case 1:
        {
            VFLViewController2 *vfl = [[VFLViewController2 alloc]init];
            vfl.number = arc4random_uniform(5);
            vc = vfl;
        }
           
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
