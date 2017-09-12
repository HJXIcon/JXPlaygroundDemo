//
//  ListImageItem.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 4/2/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REListImageItem.h"

@implementation REListImageItem

+ (REListImageItem *)itemWithImageNamed:(NSString *)imageName
{
    REListImageItem *item = [[REListImageItem alloc] init];
    item.imageName = imageName;
    return item;
}

@end
