
//
//  JXMasonryCell.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

/**！
 masmony   描述文字多的话 就以文字 的高度   如果描述文字只有一行 就有图片的高度  为底部  这个设置优先  怎么设置
 */

#import "JXMasonryCell.h"
#import "FDTModel.h"
#import "JXTopLeftLabel.h"


@interface JXMasonryCell ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;

@end
@implementation JXMasonryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

+ (instancetype)cellForTableView:(UITableView *)tableView{
    Class cellClass = NSClassFromString(NSStringFromClass(self));
    
    id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    
    if (cell == nil) {
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self)];
    }
    
    
    return cell;
}

- (void)setupUI{
    
    
    
    self.imageV = [[UIImageView alloc]init];
    self.imageV.backgroundColor = [UIColor redColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"标题标题啊是黑还得按蝴蝶耦合";
    self.desLabel = [[UILabel alloc]init];
    self.desLabel.textColor = [UIColor redColor];
    self.desLabel.backgroundColor = [UIColor yellowColor ];
    self.desLabel.text = @"des的饥饿哦我哈嘿hi哦啊哦哈的饥饿哦我哈嘿hi哦啊哦哈的饥饿哦我哈嘿hi哦啊哦哈";
    
    
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.and.height.mas_equalTo(102);
//        make.bottom.mas_lessThanOrEqualTo(-10);
        //greaterThan 大于等于
    }];
    
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.imageV.mas_top);
        make.height.mas_equalTo(23);
    }];
    
    self.desLabel.numberOfLines = 0;
    self.desLabel.preferredMaxLayoutWidth = kScreenW - 20;
    [self.contentView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(102 - 23);
        make.bottom.mas_equalTo(self.contentView).with.offset(-10).priority(200);
//        make.bottom.mas_lessThanOrEqualTo(self.contentView).with.offset(-10).priority(200);// 去除警告
    }];
    
    
    /**！
     Masonry布局技巧：http://www.jianshu.com/p/0c1d76e7ea1a
     */
    
    /**!
     约束的三种方法:
     //这个方法只会添加新的约束
     [blueView mas_makeConstraints:^(MASConstraintMaker *make)  {
     
     }];
     
     // 这个方法会将以前的所有约束删掉，添加新的约束
     [blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
     
     }];
     
     // 这个方法将会覆盖以前的某些特定的约束
     [blueView mas_updateConstraints:^(MASConstraintMaker *make) {
     
     }];
     */
    
    
}




-(void)fill:(FDTModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"iconDefault"]];
    self.titleLabel.text = model.title;
    
    self.desLabel.text = model.desc;
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
