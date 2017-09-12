//
//  ListHeaderView.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 4/2/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REListHeaderView : UIView

@property (strong, readonly, nonatomic) UIImageView *userpicImageView;
@property (strong, readonly, nonatomic) UILabel *usernameLabel;

+ (REListHeaderView *)headerViewWithImageNamed:(NSString *)imageName username:(NSString *)username;

@end
