//
//  JXCardView3DLayout.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCardView3DLayout.h"

@interface JXCardView3DLayout ()
@property(nonatomic, assign) CGFloat previousOffset;
@property(nonatomic, strong) NSIndexPath *mainIndexPath;
@property(nonatomic, strong) NSIndexPath *movingInIndexPath;
@property(nonatomic, assign) CGFloat difference;

@end
@implementation JXCardView3DLayout
#pragma mark - override
// 预布局方法 所有的布局应该写在这里面
- (void)prepareLayout
{
    [super prepareLayout];
    [self setupLayout];
}

- (void)setupLayout{
    
    CGFloat inset  = self.collectionView.bounds.size.width * (6/64.0f);
    // 向下取整
    inset = floor(inset);
    
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width - (2 *inset), self.collectionView.bounds.size.height * 3/4);
    
    self.sectionInset = UIEdgeInsetsMake(0,inset, 0,inset);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

// 是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//此方法应该返回当前屏幕正在显示的视图（cell 头尾视图）的布局属性集合（UICollectionViewLayoutAttributes 对象集合）
/**!
 方法解析：
 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 这个方法的返回值决定了rect范围内所有元素的排布方式（frame）
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    // 获取父类(流水布局)已经计算好的布局，在这个基础上做个性化修改
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSArray *cellIndices = [self.collectionView indexPathsForVisibleItems];
    
    if(cellIndices.count == 0 )
    {
        return attributes;
    }
    
    else if (cellIndices.count == 1)
    {
        _mainIndexPath = cellIndices.firstObject;
        _movingInIndexPath = nil;
    }
    else if(cellIndices.count > 1)
    {
        NSIndexPath *firstIndexPath = cellIndices.firstObject;
        if(firstIndexPath == _mainIndexPath)
        {
            _movingInIndexPath = cellIndices[1];
        }
        else
        {
            _movingInIndexPath = cellIndices.firstObject;
            _mainIndexPath = cellIndices[1];
        }
        
    }
    
    _difference =  self.collectionView.contentOffset.x - _previousOffset;
    
    _previousOffset = self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        [self applyTransformToLayoutAttributes:attribute];
    }
    return  attributes;
}

/**！
 方法解析：
 只要滚动屏幕 就会调用 方法 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 只要布局页面的属性发生改变 就会重新调用 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect 这个方法
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyTransformToLayoutAttributes:attributes];
    
    return attributes;
}




#pragma mark - private Method

- (void)applyTransformToLayoutAttributes:(UICollectionViewLayoutAttributes *)attribute
{
    if(attribute.indexPath.section == _mainIndexPath.section)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_mainIndexPath];
        attribute.transform3D = [self transformFromView:cell];
        
    }
    else if (attribute.indexPath.section == _movingInIndexPath.section)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_movingInIndexPath];
        attribute.transform3D = [self transformFromView:cell];
    }
}







- (CGFloat)angleForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width;
    CGFloat angle = (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    return angle;
}

#pragma mark - Logica
- (CGFloat)baseOffsetForView:(UIView *)view
{
    UICollectionViewCell *cell = (UICollectionViewCell *)view;
    CGFloat offset =  ([self.collectionView indexPathForCell:cell].section) * self.collectionView.bounds.size.width;
    
    return offset;
}

- (CGFloat)heightOffsetForView:(UIView *)view
{
    CGFloat height;
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width;
    //TODO:make this constant a certain proportion of the collection view
    height = 120 * (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    if(height < 0 )
    {
        height = - 1 * height;
    }
    return height;
}

- (BOOL)xAxisForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat offset = (currentOffset - baseOffsetForCurrentView);
    if(offset >= 0)
    {
        return YES;
    }
    return NO;
}

#pragma mark - Transform Related Calculation

- (CATransform3D)transformFromView:(UIView *)view
{
    CGFloat angle = [self angleForView:view];
    CGFloat height = [self heightOffsetForView:view];
    BOOL xAxis = [self xAxisForView:view];
    return [self transformfromAngle:angle height:height xAxis:xAxis];
}

- (CATransform3D)transformfromAngle:(CGFloat)angle height:(CGFloat)height xAxis:(BOOL)axis
{
    CATransform3D t = CATransform3DIdentity;
    t.m34  = 1.0/-500;
    
    if (axis)
    {
        t = CATransform3DRotate(t,angle, 1, 1, 0);
    }
    else
    {
        t = CATransform3DRotate(t,angle, -1, 1, 0);
    }
    
    return t;
}


@end
