//
//  ReativeSearchViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ReativeSearchViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ReactiveCocoaBlockViewController.h"

@interface ReativeSearchViewController ()

@property (strong, nonatomic)  UITextField *searchTextField;
@end

@implementation ReativeSearchViewController
- (UITextField *)searchTextField{
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 30)];
        _searchTextField.placeholder = @"输入关键词搜索";
        _searchTextField.layer.borderWidth = 0.5;
        _searchTextField.layer.borderColor = [UIColor orangeColor].CGColor;
        
    }
    return _searchTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchTextField];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"block嵌套" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    [self setupSearchSignal];
    
}

- (void)rightAction{
    
    [self.navigationController pushViewController:[[ReactiveCocoaBlockViewController alloc]init] animated:YES];
}

- (void)setupSearchSignal {
    
    @weakify(self);
    
    [[[[[self.searchTextField.rac_textSignal filter:^BOOL(NSString * _Nullable searchKeyword) {
        
         // 1.先将不合法的搜索词过滤掉（返回的bool值决定了signal是否继续向下传递
        return (searchKeyword.length);
        
    }]
        // 2.因为没必要每次一输入便进行网络请求，所以0.5s之后，才进行搜索。(throttle是在规定时间后，信号继续向下传递)
        throttle:0.5]
     
       // 3.网络请求将会返回signal，所以直接使用flattenMap来映射，而不必用map
     flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable searchKeyword) {
        
         @strongify(self);
         
         // 4.发起网络请求
         return [self searchWithKeyword:searchKeyword];
         
     // 5.回到主线程，因为在signal订阅中可能更新界面
    }] deliverOnMainThread]
    
      // 6.订阅网络请求返回的信号
     subscribeNext:^(id  _Nullable x) {
         
         NSLog(@"search == %@", x);
         
     }];
    
    
    
}

/// 因为在我的设计中，网络请求成功以后，会返回一个信号，所以使用 flattenMap 将以前搜索框的信号直接映射成网络请求返回的信号。
- (RACSignal *)searchWithKeyword:(NSString *)keyword {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [subscriber sendNext:[NSString stringWithFormat:@"搜索%@网络数据返回结果",keyword]];
            
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
