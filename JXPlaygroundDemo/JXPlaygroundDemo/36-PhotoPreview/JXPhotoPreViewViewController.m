//
//  JXPhotoPreViewViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/18.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPhotoPreViewViewController.h"
#import "PhotoPreViewViewController.h"

@interface JXPhotoPreViewViewController ()

@end

@implementation JXPhotoPreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"浏览图片" style:0 target:self action:@selector(showImageAction)];
}


- (void)showImageAction{
    
    PhotoPreViewViewController *vc = [[PhotoPreViewViewController alloc]init];
    vc.dataSource = [@[
                      @"http://img2.imgtn.bdimg.com/it/u=2974104803,1439396293&fm=200&gp=0.jpg",
                      @"http://img2.imgtn.bdimg.com/it/u=2974104803,1439396293&fm=200&gp=0.jpg",
                      @"http://img2.imgtn.bdimg.com/it/u=2974104803,1439396293&fm=200&gp=0.jpg",
                      @"http://img2.imgtn.bdimg.com/it/u=2974104803,1439396293&fm=200&gp=0.jpg",
                      @"http://img2.imgtn.bdimg.com/it/u=2974104803,1439396293&fm=200&gp=0.jpg",
                      @"http://img2.imgtn.bdimg.com/it/u=2974104803,1439396293&fm=200&gp=0.jpg"
                      ]copy];
    vc.deleteNeeded = YES;
    vc.downLoadNeeded = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
