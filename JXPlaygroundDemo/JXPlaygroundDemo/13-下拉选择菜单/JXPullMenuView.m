//
//  JXPullMenuView.m
//  FishingWorld
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import "JXPullMenuView.h"
#import "JXPullMenuModel.h"
#import "JXPullMenuCell.h"

@interface JXPullMenuView ()

@property(nonatomic,strong) UILabel *LeftLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *subTitleLabel;
@property(nonatomic,strong) UIImageView *arrowImageV;
@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *data; // 模型
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,strong) UIView *lineV;

@end
@implementation JXPullMenuView
#pragma mark - setter
- (void)setSeleIndex:(NSInteger)seleIndex{
    _seleIndex = seleIndex;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:seleIndex inSection:0];
    
    /// 代理调用方法
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
}


- (id)initWithFrame:(CGRect)frame Data:(NSArray *)data leftText:(NSString *)leftText
{
    self.data = [NSArray arrayWithArray:data];
    self.leftText = leftText;
    
    return [self initWithFrame:frame];
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // leftLabel
        self.LeftLabel = [[UILabel alloc]init];
        self.LeftLabel.adjustsFontSizeToFitWidth = YES;
        self.LeftLabel.text = self.leftText;
        
        
        // title
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.text = @"请选择";
        self.titleLabel.textColor = kRGBAColor(170, 170, 170, 1);
        
        
        // subTitle
        self.subTitleLabel = [[UILabel alloc]init];
        self.subTitleLabel.font = [UIFont systemFontOfSize:10];
        self.subTitleLabel.textColor = kRGBAColor(170, 170, 170, 1);
        self.subTitleLabel.numberOfLines = 0;
        
        // arrowImage
        self.arrowImageV = [[UIImageView alloc]init];
        self.arrowImageV.image = [UIImage imageNamed:@"cellArrow"];
        
       NSArray *views =  @[self.LeftLabel,self.titleLabel,self.subTitleLabel,self.arrowImageV];
        
        [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self addSubview:obj];
        }];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.btn];
        
        
        // lineV
        self.lineV = [[UIView alloc]init];
        self.lineV.backgroundColor = kRGBAColor(200, 200, 200, 1);
        self.lineV.hidden = YES;
        [self addSubview:self.lineV];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0) style:UITableViewStylePlain];
        [self.tableView setDelegate:(id<UITableViewDelegate>)self];
        [self.tableView setDataSource:(id<UITableViewDataSource>)self];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        [self.tableView.layer setMasksToBounds:YES];
        [self.tableView.layer setShadowColor:[UIColor grayColor].CGColor];
        [self addSubview:self.tableView];
        [self.tableView setBackgroundView:nil];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setMasksToBounds:YES];
        [self.layer setShadowColor:[UIColor grayColor].CGColor];
        [self setClipsToBounds:NO];
        self.status = PullMenuStatus_diss;
        [self.tableView resignFirstResponder];
        
        
        
    }
    return self;
}

#pragma mark - Actions
-(void)buttonClick:(id)sender
{
    if (self.status == PullMenuStatus_show) {
        [self dismiss];
    }
    else
    {
        [self show];
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (v == nil) {
        CGPoint tp = [self.tableView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.tableView.bounds, tp)) {
            v = self.tableView;
        }
    }
    
    return v;
}



-(void)show
{
   
    [UIView animateWithDuration:0.2 animations:^{
        self.arrowImageV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
             self.lineV.hidden = NO;
            [self.tableView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height * self.data.count)];
            self.status = PullMenuStatus_show;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.arrowImageV.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.lineV.hidden = YES;
            [self.tableView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
            self.status = PullMenuStatus_diss;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.status == PullMenuStatus_show) {
        [self dismiss];
    }
    else
    {
        [self show];
    }
    return NO;
}

#pragma mark - 数据源
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXPullMenuCell *cell = [JXPullMenuCell cellOfCellConfigWithTableView:tableView];
    
    JXPullMenuModel *model = self.data[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXPullMenuModel *model = self.data[indexPath.row];
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
    
    if(self.valueChangeBlock)
    {
        self.valueChangeBlock(model,indexPath.row);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismiss];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat labelH = 35;
    CGFloat arrowW = 15;
    CGFloat arrowH = 15;
    self.LeftLabel.frame = CGRectMake(20, (self.height - labelH) * 0.5, self.width * 0.18, labelH);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.LeftLabel.frame) + JXMargin, (self.height - labelH) * 0.5, self.width * 0.15, labelH);
    
    self.arrowImageV.frame = CGRectMake(self.width - arrowW - 10, (self.height - arrowH) * 0.5, arrowW, arrowH);
    
    self.subTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + JXMargin, 0, self.width - arrowW - CGRectGetMaxX(self.titleLabel.frame) - CGRectGetWidth(self.arrowImageV.frame) - 15, self.height);
    
    self.lineV.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    
    self.btn.frame = self.bounds;
}

@end
