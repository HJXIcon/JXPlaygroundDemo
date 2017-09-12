//
//  ListImageItem.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 4/2/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETableViewItem.h"

@interface REListImageItem : RETableViewItem

@property (copy, readwrite, nonatomic) NSString *imageName;

+ (REListImageItem *)itemWithImageNamed:(NSString *)imageName;

@end
