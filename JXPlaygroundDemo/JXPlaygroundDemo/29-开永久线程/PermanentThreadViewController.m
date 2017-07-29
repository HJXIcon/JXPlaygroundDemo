//
//  PermanentThreadViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/7/29.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "PermanentThreadViewController.h"

/**!
 参考文章 ：http://www.cocoachina.com/ios/20160728/17220.html
 */

@interface PermanentThreadViewController ()

@property (strong, nonatomic) NSPort *emptyPort;
@property (strong, nonatomic) NSThread *thread;
@property (assign, nonatomic) BOOL shouldKeepRunning;

@end

@implementation PermanentThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"永久线程";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self runloopTest];
}

- (void)runloopTest{
    //  绘制按钮，点击按钮后关闭 runloop
    UIButton *stopButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [stopButton setTitle:@"Stop Timer" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:stopButton];
    [stopButton addTarget:self action:@selector(stopButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //    self.shouldKeepRunning = YES;
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThread) object:nil];
    [self.thread start];
    
    [self performSelector:@selector(printSomething) onThread:self.thread withObject:nil waitUntilDone:YES];
    
    
}

- (void)singleThread {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        if (!self.emptyPort) {
            self.emptyPort = [NSMachPort port];
        }
        [runLoop addPort:self.emptyPort forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
        //        while (_shouldKeepRunning && [runLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]]);
    }
}



- (void)printSomething {
    NSLog(@"current thread = %@", [NSThread currentThread]);
    [self performSelector:@selector(printSomething) withObject:nil afterDelay:3];
}


#pragma --mark 点击按钮退出
- (void)stopButtonDidClicked:(id)sender {
    [self performSelector:@selector(stopRunloop) onThread:self.thread withObject:nil waitUntilDone:YES];
}


- (void)stopRunloop {
    // self.shouldKeepRunning = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
