//
//  JXAnimatedCollectionViewLayout.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAnimatedCollectionViewLayout.h"


@implementation JXAnimatedCollectionViewLayout


+ (Class)layoutAttributesClass{
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
            // 转换attributes
            [tmpArray addObject:[self transformLayoutAttributes:a]];
        }
        
    }
    
    return tmpArray;
    
}

//是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}




// 转换attributes
- (UICollectionViewLayoutAttributes *)transformLayoutAttributes:(JXAnimatedCollectionViewLayoutAttributes *)attributes{
    
    if (!self.collectionView) {
        return attributes;
    }
    
    
    JXAnimatedCollectionViewLayoutAttributes *a = attributes;
    
    CGFloat distance = 0;
    CGFloat itemOffset = 0;
    
    // 水平方向
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        distance = self.collectionView.frame.size.width;
        // itemOffset = item的中心点 - Collectionview的偏移量x
        /**!
    itemIndex   itemOffset
         0      160
         1      160 + 320 * 1
         2      160 + 320 * 2
         ...    ...
         */
        itemOffset = a.center.x - self.collectionView.contentOffset.x;
        a.startOffset = (a.frame.origin.x - self.collectionView.contentOffset.x) / a.frame.size.width;
        a.endOffset = (a.frame.origin.x - self.collectionView.contentOffset.x - self.collectionView.frame.size.width) / a.frame.size.width;
        
        JXLog(@"distance == %f",distance);
        JXLog(@"itemOffset == %f",itemOffset);
        JXLog(@"a.frame.origin.x == %f",a.frame.origin.x);
        JXLog(@"self.collectionView.contentOffset.x == %f",self.collectionView.contentOffset.x);
         JXLog(@"a.frame.size.width == %f",a.frame.size.width);
        JXLog(@"startOffset == %f",a.startOffset);
        JXLog(@"endOffset == %f",a.endOffset);
        
        
    }else {
        distance = self.collectionView.frame.size.height;
        itemOffset = a.center.y - self.collectionView.contentOffset.y;
        a.startOffset = (a.frame.origin.y - self.collectionView.contentOffset.y) / a.frame.size.height;
        a.endOffset = (a.frame.origin.y - self.collectionView.contentOffset.y - self.collectionView.frame.size.height) / a.frame.size.height;
    }
    
    a.scrollDirection = self.scrollDirection;
    a.middleOffset = itemOffset / distance - 0.5;
    JXLog(@"middleOffset == %f",a.middleOffset);
    NSLog(@"--------------------------");
    
    // Cache the contentView since we're going to use it a lot.
    UIView *c = [self.collectionView cellForItemAtIndexPath:attributes.indexPath].contentView;
    
    if (a.contentView == nil && c){
        a.contentView = c;
        
    }
    
    /// 执行代理
    if ([self.animator respondsToSelector:@selector(animate:WithAttributes:)]) {
        
        [self.animator animate:self.collectionView WithAttributes:a];
    }
    
    return a;
}


/**!
 //预布局方法 所有的布局应该写在这里面
 - (void)prepareLayout
 
 //此方法应该返回当前屏幕正在显示的视图（cell 头尾视图）的布局属性集合（UICollectionViewLayoutAttributes 对象集合）
 - (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 
 //根据indexPath去对应的UICollectionViewLayoutAttributes  这个是取值的，要重写，在移动删除的时候系统会调用改方法重新去UICollectionViewLayoutAttributes然后布局
 - (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
 - (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
 
 //返回当前的ContentSize
 - (CGSize)collectionViewContentSize
 //是否重新布局
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 
 //这4个方法用来处理插入、删除和移动cell时的一些动画 瀑布流代码详解
 - (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
 - (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
 - (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
 - (void)finalizeCollectionViewUpdates
 
 //9.0之后处理移动相关
 - (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<nsindexpath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<nsindexpath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition NS_AVAILABLE_IOS(9_0)
 - (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<nsindexpath *> *)indexPaths previousIndexPaths:(NSArray<nsindexpath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled NS_AVAILABLE_IOS(9_0)</nsindexpath *></nsindexpath *></nsindexpath *></nsindexpath *>
 
 */


@end
