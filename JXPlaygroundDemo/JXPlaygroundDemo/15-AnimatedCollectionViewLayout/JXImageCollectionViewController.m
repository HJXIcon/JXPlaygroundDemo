//
//  JXImageCollectionViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXImageCollectionViewController.h"
#import "JXAnimatedCollectionViewLayout.h"
#import "JXLayoutAttributesAnimator.h"

@interface JXImageCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JXImageCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        JXAnimatedCollectionViewLayout *layout =[[JXAnimatedCollectionViewLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(kScreenW, kScreenH);
        layout.animator = self.animator;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor redColor];
        // Register cell classes
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"自定义layout";
    [self.view addSubview:self.collectionView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[JXAnimatedCollectionViewLayout class]]) {
        JXAnimatedCollectionViewLayout *layout = (JXAnimatedCollectionViewLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(kScreenW, kScreenH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        layout.animator = self.animator;
        
    }
    
    
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.contentView.backgroundColor = JXColor(arc4random() / 255.0, arc4random() / 255.0, arc4random() / 255.0);
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kScreenW, kScreenH);
}


@end
