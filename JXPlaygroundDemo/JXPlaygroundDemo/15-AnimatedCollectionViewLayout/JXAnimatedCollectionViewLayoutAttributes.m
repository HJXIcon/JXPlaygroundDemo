//
//  JXAnimatedCollectionViewLayoutAttributes.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAnimatedCollectionViewLayoutAttributes.h"

@implementation JXAnimatedCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone{
    
    
    [self initialize];
    
    JXAnimatedCollectionViewLayoutAttributes  *copy = (JXAnimatedCollectionViewLayoutAttributes *)[super copyWithZone:zone];
    copy.contentView = self.contentView;
    copy.scrollDirection = self.scrollDirection;
    copy.startOffset = self.startOffset;
    copy.middleOffset = self.middleOffset;
    copy.endOffset = self.endOffset;
    
    return copy;
    
}

- (void)initialize{
    self.startOffset = 0;
    self.endOffset = 0;
    self.middleOffset = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (BOOL)isEqual:(id)object{
    
    if (![object isKindOfClass:[JXAnimatedCollectionViewLayoutAttributes class]]) {
        return NO;
    }
    
    JXAnimatedCollectionViewLayoutAttributes *attributes = (JXAnimatedCollectionViewLayoutAttributes *)object;
    
    return [super isEqual:attributes]
    && attributes.contentView == self.contentView
    && attributes.scrollDirection == self.scrollDirection
    && attributes.startOffset == self.startOffset
    && attributes.middleOffset == self.middleOffset
    && attributes.endOffset == self.endOffset;
}

@end
