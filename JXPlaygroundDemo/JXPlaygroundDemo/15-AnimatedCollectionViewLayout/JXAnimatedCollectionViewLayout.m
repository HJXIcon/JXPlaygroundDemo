//
//  JXAnimatedCollectionViewLayout.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAnimatedCollectionViewLayout.h"


@implementation JXAnimatedCollectionViewLayout

- (Class)layoutAttributesClass{
    return [JXAnimatedCollectionViewLayoutAttributes class];
}

//此方法应该返回当前屏幕正在显示的视图（cell 头尾视图）的布局属性集合（UICollectionViewLayoutAttributes 对象集合
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    if (attributes.count == 0) {
        return nil;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        
        if ([attribute isKindOfClass:[JXAnimatedCollectionViewLayoutAttributes class]]) {
            JXAnimatedCollectionViewLayoutAttributes *a =(JXAnimatedCollectionViewLayoutAttributes *)attribute;
            [tmpArray addObject:[self transformLayoutAttributes:a]];
        }
        
    }
    
    return tmpArray;
    
}

//是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}




// 转换
- (UICollectionViewLayoutAttributes *)transformLayoutAttributes:(JXAnimatedCollectionViewLayoutAttributes *)attributes{
    
    if (!self.collectionView) {
        return attributes;
    }
    
    
    JXAnimatedCollectionViewLayoutAttributes *a = attributes;
    
    CGFloat distance = 0;
    CGFloat itemOffset = 0;
    
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        distance = self.collectionView.frame.size.width;
        itemOffset = a.center.x - self.collectionView.contentOffset.x;
        a.startOffset = (a.frame.origin.x - self.collectionView.contentOffset.x) / a.frame.size.width;
        a.endOffset = (a.frame.origin.x - self.collectionView.contentOffset.x - self.collectionView.frame.size.width) / a.frame.size.width;
        
    }else {
        distance = self.collectionView.frame.size.height;
        itemOffset = a.center.y - self.collectionView.contentOffset.y;
        a.startOffset = (a.frame.origin.y - self.collectionView.contentOffset.y) / a.frame.size.height;
        a.endOffset = (a.frame.origin.y - self.collectionView.contentOffset.y - self.collectionView.frame.size.height) / a.frame.size.height;
    }
    
    a.scrollDirection = self.scrollDirection;
    a.middleOffset = itemOffset / distance - 0.5;
    
    // Cache the contentView since we're going to use it a lot.
    if (a.contentView == nil){
        
        UIView *c = [self.collectionView cellForItemAtIndexPath:attributes.indexPath].contentView;
        
        a.contentView = c;
        
        [self.animator animate:self.collectionView WithAttributes:a];
    }
    
    
    return a;
}

//返回当前的ContentSize
- (CGSize)collectionViewContentSiz{
    
    return CGSizeMake(kScreenW, kScreenH);
}


@end
