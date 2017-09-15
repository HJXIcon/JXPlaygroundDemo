//
//  JXGCDViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/15.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXGCDViewController.h"
#import "GCD.h"

@interface JXGCDViewController ()
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, strong) GCDSemaphore *sem;
@end

@implementation JXGCDViewController
/**！
 封装GCD以及介绍如何使用:
 http://www.cnblogs.com/YouXianMing/p/3659204.html
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送信号" style:UIBarButtonItemStylePlain target:self action:@selector(singeAction)];
    
    
    self.title = @"GCD封装";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [GCDQueue executeInGlobalQueue:^{
        
        // download task, etc
        
        [GCDQueue executeInMainQueue:^{
            
            // update UI
        }];
    }];
    
    
    
    
    // init group
    GCDGroup *group = [GCDGroup new];
    
    // add to group
    [[GCDQueue globalQueue] execute:^{
        
        // task one
        
    } inGroup:group];
    
    // add to group
    [[GCDQueue globalQueue] execute:^{
        
        // task two
        
    } inGroup:group];
    
    // notify in mainQueue
    [[GCDQueue mainQueue] notify:^{
        
        // task three
        
    } inGroup:group];
    
    
    
    
    // init timer
    self.timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    
    // timer event
    [self.timer event:^{
        
        // task
        
    } timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 3];
    
    // start timer
    [self.timer start];
    
    
    
    
    // init semaphore
    GCDSemaphore *semaphore = [GCDSemaphore new];
    
    // wait
    [GCDQueue executeInGlobalQueue:^{
        
        [semaphore wait];
        
        // todo sth else
    }];
    
    // signal
    [GCDQueue executeInGlobalQueue:^{
        
        // do sth
        [semaphore signal];
    }];
    
    
    /// 使用信号量
    _sem = [[GCDSemaphore alloc] init];
    
    GCDTimer *timer = [[GCDTimer alloc] initInQueue:[GCDQueue globalQueue]];
    [timer event:^{
        [_sem signal];
    } timeInterval:NSEC_PER_SEC];
    [timer start];
    
    [[GCDQueue globalQueue] execute:^{
        while (1)
        {
            [_sem wait];
            NSLog(@"Y.X.");
        }
    }];
    
    
}

/// 此定时器不能暂停,只能销毁后释放掉对象.
- (void)dealloc{
    [self.timer destroy];
}

- (void)singeAction{
    
    [_sem signal];
}
@end
