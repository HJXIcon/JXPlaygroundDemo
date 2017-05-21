//
//  ViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoaViewController.h"
#import "JXAMapViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation ViewController

- (NSArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = @[
                        @"ReactiveCocoa练习",
                        @"高德地图"
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    float value = [NSObject makeCaculators:^(JXCaculatorMaker *maker) {
        maker.add(1).add(2).add(3).add(4);
    }];
    
    NSLog(@"value === %f",value);
    
    
    JXCaculator *caculator = [[JXCaculator alloc]init];
    
    BOOL isEqule = [[[caculator caculator:^float(float result) {
        
        result += 2;
        result *= 5;
        
        return result;
    }] equle:^BOOL(float result) {
        
        return result == 11;
        
    }] isEqule];
    
    
    NSLog(@"isEqule == %d",isEqule);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [[ReactiveCocoaViewController alloc]init];
            break;
            
        case 1:
            vc = [[JXAMapViewController alloc]init];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
