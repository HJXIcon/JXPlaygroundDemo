//
//  JXPopupView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopupInnerView.h"
#import "JXPopupView.h"

#pragma mark - ** cell

@interface JXPopupViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIButton *selectBtn;


@end

@implementation JXPopupViewCell

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"商品质量太差/拍错";
    }
    return _contentLabel;
}

- (UIButton *)selectBtn{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_selectBtn setImage:[UIImage imageNamed:@"off_choose"] forState:UIControlStateNormal];
         [_selectBtn setImage:[UIImage imageNamed:@"no_choose"] forState:UIControlStateSelected];
        _selectBtn.adjustsImageWhenHighlighted = NO;
        _selectBtn.adjustsImageWhenDisabled = NO;
        _selectBtn.userInteractionEnabled = NO;
        
    }
    return _selectBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLabel
         ];
        [self.contentView addSubview:self.selectBtn];
    }

    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnWH = 15;
    self.selectBtn.frame = CGRectMake(10, (self.contentView.height - btnWH) * 0.5, btnWH, btnWH);
    
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + 10, 0, self.contentView.width - CGRectGetMaxX(self.selectBtn.frame) - 20, self.contentView.height);
}

@end

#pragma mark - ***JXPopupInnerView

@interface JXPopupInnerView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@end
@implementation JXPopupInnerView

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JXPopupViewCell class] forCellReuseIdentifier:@"popCell"];
        _tableView.rowHeight = 44;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        
    }
    return _tableView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tableView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contents.count == 0 ? 1 : self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JXPopupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popCell"];
    
    if (indexPath.row == self.selIndex) {
        cell.selectBtn.selected = YES;
    }
    
    if (self.contents.count) {
        cell.contentLabel.text = self.contents[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JXPopupViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selIndex inSection:0]];
    lastCell.selectBtn.selected = NO;
    
    JXPopupViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = YES;
    
    // dismiss
    [_parentVC jx_dismissPopupView];
    
    // callback
    if (self.selectCompletion) {
        self.selectCompletion(cell.contentLabel.text,indexPath.row);
    }


}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JXPopupViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = NO;
}

#pragma mark - public
+ (instancetype)defaultPopupView{
    
     return [[JXPopupInnerView alloc]initWithFrame:CGRectMake(0, 0, 195, 210)];
}






@end
