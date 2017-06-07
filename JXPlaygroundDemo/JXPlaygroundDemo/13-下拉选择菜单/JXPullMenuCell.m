//
//  JXPullMenuCell.m
//  FishingWorld
//
//  Created by mac on 17/2/10.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import "JXPullMenuCell.h"
#import "JXPullMenuModel.h"

@interface JXPullMenuCell ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;

@end
@implementation JXPullMenuCell

- (void)setModel:(JXPullMenuModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    
    return self;
}

- (void)setupUI{
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textColor = kRGBAColor(170, 170, 170, 1);
    
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:10];
    self.subTitleLabel.textColor = kRGBAColor(170, 170, 170, 1);

   [ @[self.titleLabel,self.subTitleLabel] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
           [self.contentView addSubview:obj];
    }];
    
    

    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).offset(self.width * 0.28);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.width * 0.2);
        
    }];
    
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(5);
        
    }];
    
}

+ (instancetype )cellOfCellConfigWithTableView:(UITableView *)tableView{
    
    Class cellClass = NSClassFromString(NSStringFromClass(self));
    
    id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    
    if (cell == nil) {
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self)];
    }
    
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
