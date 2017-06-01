//
//  JXBanTangHeaderView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXBanTangHeaderView.h"
#import "UIView+Extension.h"
#import "UIImage+JQImage.h"


@interface JXBanTangHeaderView ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *emailButton;
@end

@implementation JXBanTangHeaderView

#pragma mark - lazy load
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-(self.width-60), 30, self.width-80, 30)];
        _searchBar.placeholder = @"搜索值得买的好物";
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        
        // 设置搜索框中文本框的背景
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:_searchBar.size] forState:UIControlStateNormal];
        
        [_searchBar setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.4] size:_searchBar.size] ];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        
    }
    return _searchBar;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
        
    }
    return _searchButton;
}

- (UIButton *)emailButton {
    if (!_emailButton) {
        _emailButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width-45, 30, 30, 30)];
        [_emailButton setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
        
    }
    return _emailButton;
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchBar];
        [self addSubview:self.searchButton];
        [self addSubview:self.emailButton];
        
        
    }
    return self;
}


//当自己重写一个UIView的时候有可能用到这个方法,当本视图的父类视图改变的时候,系统会自动的执行这个方法.newSuperview是本视图的新父类视图.newSuperview有可能是nil.
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    for (UITableView *tableView in self.tableViews) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    UITableView *tableView = (UITableView *)object;
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    
    UIColor * color = [UIColor whiteColor];
    // MIN函数用于返回一个列范围内的最小非空值
    CGFloat alpha = MIN(1, tableViewoffsetY/136);
    
    self.backgroundColor = [color colorWithAlphaComponent:alpha];
    
    if (tableViewoffsetY < 125){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.searchButton.hidden = NO;
            [self.emailButton setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
            self.searchBar.frame = CGRectMake(-(self.width-60), 30, self.width-80, 30);
            self.emailButton.alpha = 1-alpha;
            self.searchButton.alpha = 1-alpha;
            
            
        }];
    } else if (tableViewoffsetY >= 125){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.searchBar.frame = CGRectMake(20, 30, self.width-80, 30);
            self.searchButton.hidden = YES;
            self.emailButton.alpha = 1;
            [self.emailButton setBackgroundImage:[UIImage imageNamed:@"home_email_red"] forState:UIControlStateNormal];
        }];
    }
    
}




@end
