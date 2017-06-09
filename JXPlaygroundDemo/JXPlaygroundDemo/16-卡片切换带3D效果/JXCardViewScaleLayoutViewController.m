//
//  JXCardViewScaleLayoutViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCardViewScaleLayoutViewController.h"
#import "JXCardViewScaleLayout.h"
@interface JXCardViewScaleLayoutViewController ()

@end

@implementation JXCardViewScaleLayoutViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
    JXCardViewScaleLayout *layout = [[JXCardViewScaleLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenW * 3/4, kScreenH * 3/4 - 64);
    return [self initWithCollectionViewLayout:layout];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CardViewScaleLayout";
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = KWhiteColor;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = kRandomColorKRGBColor;
    
    return cell;
}


@end
