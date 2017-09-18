//
//  PhotoPreViewViewController.m
//  IHK
//
//  Created by 郑文明 on 16/2/25.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "PhotoPreViewViewController.h"
#import "PreviewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PhotoPreViewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    
}
@property(nonatomic,assign)BOOL isHideNaviBar;
@end

@implementation PhotoPreViewViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)deleteTheImage:(UIBarButtonItem *)sender{
    
    if (self.deleteBlock) {
        self.deleteBlock(self.dataSource,self.currentPhotoIndex,_collectionView);
    }
    
//    if (self.dataSource.count==1) {
//        [self.dataSource removeObjectAtIndex:self.currentPhotoIndex-1];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteTheImage" object:self.dataSource];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.dataSource removeObjectAtIndex:self.currentPhotoIndex-1];
//        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex,self.dataSource.count];
//        [_collectionView reloadData];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteTheImage" object:self.dataSource];
//    }

}
#pragma mark
#pragma mark initUI
-(void)initUI{
   self.isHideNaviBar = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kScreenW, kScreenH);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(kScreenW * self.dataSource.count, kScreenH);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[PreviewCell class] forCellWithReuseIdentifier:@"PreviewCell"];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.currentPhotoIndex-1) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.downLoadNeeded) {
      UIButton *_saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveImageBtn.frame = CGRectMake(0, 0, 40, 40);
        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_saveImageBtn setImage:[UIImage imageNamed:@"downLoadImage"] forState:UIControlStateNormal];
        [_saveImageBtn setImage:[UIImage imageNamed:@"downLoadImage"] forState:UIControlStateHighlighted];
        [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveImageBtn];
    }else if(self.deleteNeeded){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTheImage:)];
    }
    self.currentPhotoIndex =  self.currentPhotoIndex?self.currentPhotoIndex:1;
    self.title = self.title?self.title:[NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex,self.dataSource.count];
    self.view.backgroundColor = [UIColor blackColor];
    [self initUI];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPhotoIndex-1 inSection:0];
        PreviewCell *currentCell = (PreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImageWriteToSavedPhotosAlbum(currentCell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败" ToView:self.view];
        
    } else {
        [MBProgressHUD showSuccess:@"保存成功" ToView:self.view];
    }
    if (self.downLoadBlock) {
        self.downLoadBlock(self.dataSource,image,error);
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.title isEqualToString:@"图片预览"]) {
        
    }else{
        CGPoint offSet = scrollView.contentOffset;
        self.currentPhotoIndex = offSet.x / self.view.width+1;
        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex,self.dataSource.count];
    }
    if (self.currentPhotoIndex==1) {
        scrollView.bounces = NO;
    }else{
        scrollView.bounces = YES;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PreviewCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            if (weakSelf.isHideNaviBar==YES) {
                [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
            }else{
                [weakSelf.navigationController setNavigationBarHidden:YES animated:YES];
            }
            weakSelf.isHideNaviBar = !weakSelf.isHideNaviBar;
        };
    }
    cell.currentIndexPath = indexPath;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex,self.dataSource.count];
    return cell;
}



- (void)showPhotoBytes {
//    [[TZImageManager manager] getPhotosBytesWithArray:@[_photoArr[_currentIndex]] completion:^(NSString *totalBytes) {
//        _originalPhotoLable.text = [NSString stringWithFormat:@"(%@)",totalBytes];
//    }];
}

//-(UIImageView *)currentZoomView{
//    UIImageView *IV = mainSV.subviews[self.currentPhotoIndex-1];
//    return IV;
//}
#pragma mark - UITapGestureRecognizer Event

//- (void)doubleTap:(UITapGestureRecognizer *)tap {
//
//    if (mainSV.zoomScale > 1.0) {
//        [mainSV setZoomScale:1.0 animated:YES];
//    } else {
//        CGPoint touchPoint = [tap locationInView:[self currentZoomView]];
//        CGFloat newZoomScale = mainSV.maximumZoomScale;
//        CGFloat xsize = self.view.frame.size.width / newZoomScale;
//        CGFloat ysize = self.view.frame.size.height / newZoomScale;
//        [mainSV zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
//    }
//}

- (void)singleTap:(UITapGestureRecognizer *)tap {
//    if (self.singleTapGestureBlock) {
//        self.singleTapGestureBlock();
//    }
    NSLog(@"singleTap");
}
#pragma mark
#pragma mark  scrollView delegate

//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return [self currentZoomView];
//}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    CGFloat offsetX = (mainSV.frame.size.width > mainSV.contentSize.width) ? (mainSV.frame.size.width - mainSV.contentSize.width) * 0.5 : 0.0;
//    CGFloat offsetY = (mainSV.frame.size.height > mainSV.contentSize.height) ? (mainSV.frame.size.height - mainSV.contentSize.height) * 0.5 : 0.0;
//    [self currentZoomView].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
//}
- (void)dealloc
{
    JXLog(@"%s dealloc",object_getClassName(self));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
