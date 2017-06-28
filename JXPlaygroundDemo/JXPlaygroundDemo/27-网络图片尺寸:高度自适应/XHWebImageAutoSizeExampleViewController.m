//
//  XHWebImageAutoSizeExampleViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "XHWebImageAutoSizeExampleViewController.h"
#import <XHWebImageAutoSize.h>
#import "UIImage+JXExtension.h"
@interface XHWebImageAutoSizeExampleViewController ()



@end

@implementation XHWebImageAutoSizeExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"XHWebImageAutoSizeExample";
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(400);
        
    }];
    
    //加载网络图片使用SDWebImage
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://img000.hc360.cn/m8/M04/64/80/wKhQplavhfCEGJamAAAAAORMrSY626.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        /**
         *  缓存image size
         */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            
            /**
             *  reload item
             */
            if(result) {
               CGSize size =  [XHWebImageAutoSize imageSizeFromCacheForURL:imageURL];
                
                
                CGRect rect = CGRectMake((size.width - CGRectGetWidth(imageView.frame)) * 0.5, (size.height - CGRectGetHeight(imageView.frame)) * 0.5, imageView.bounds.size.width, imageView.bounds.size.height);
                
                imageView.image = [UIImage getSubImageRect:rect andImage:image];
            }
        }];
        
    }];
    
    
}




@end
