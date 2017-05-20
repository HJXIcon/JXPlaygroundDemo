//
//  ReactiveCocoaViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ReactiveCocoaBlockViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ReactiveCocoaBlockViewController ()

@end

@implementation ReactiveCocoaBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"有序的执行网络请求";
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setupRequestSignal2];
}






/*!
 2.同时发起多个请求，直到全部完成
 
 这个需求可以用之前的 combineLatest 方法，也可以用 merge 方法。这两个方法都是要在全部信号都 sendNext 以后才会触发最终结果的。
 
 */
- (void)setupRequestSignal2{
    
    RACSignal *signal1 = [self request1];
    RACSignal *signal2 = [self request2];
    
    [[signal1 merge:signal2] subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
}


///  1.有序的执行网络请求
- (void)setupRequestSignal {
    
    // 假设发起两个请求
    // request1与request2是自定义方法，会返回两个信号
    RACSignal *signal1 = [self request1];
    RACSignal *signal2 = [self request2];
    
    /// concat:这个方法会在第一个信号 sendNext 之后，才会激活第二个信号，从而达到有序触发的目的
    [[signal1 concat:signal2] subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
}



- (RACSignal *)request1 {
    
    // 1.创建信号
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 2.发送信号
            [subscriber sendNext:@"请求1完成"];
            [subscriber sendCompleted];
            
        
        });
        
         // 3. 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
        
    }];
    
     // 最后:订阅信号,才会激活信号在：[self setupRequestSignal]中
}


- (RACSignal *)request2 {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [subscriber sendNext:@"请求2完成"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}



@end
