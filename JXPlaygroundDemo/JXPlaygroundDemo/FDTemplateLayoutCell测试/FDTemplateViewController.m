//
//  FDTemplateViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "FDTemplateViewController.h"
#import "FDTCell.h"
#import "FDTMasoryCell.h"
#import "FDTModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JXMasonryCell.h"

static NSString *const cellID = @"FDTCell";
static NSString *const cellMasonryID  = @"FDTMasonryCell";

@interface FDTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  *tableview;
@property (nonatomic,strong) NSMutableArray  *dataArry;

@end

@implementation FDTemplateViewController

-(NSMutableArray *)dataArry{
    if(_dataArry == nil){
        _dataArry = [NSMutableArray array];
        
        for (int i = 0; i < 20; i++) {
            FDTModel *model = [[FDTModel alloc] init];
            model.iconUrl = @"http://img5q.duitang.com/uploads/item/201501/26/20150126200657_HMUR3.thumb.700_0.jpeg";
            model.title = [NSString stringWithFormat:@"第%d个title",i+1];
            NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"这是第%d个",i]];
            NSInteger max = arc4random_uniform(10);
            for (int i = 0; i < max ; i++) {
                [str appendString:@"我的凑数的啊  啊的凑数的啊"];
            }
            model.desc = (NSString *)str;
            [_dataArry addObject:model];
        }
        
    }
    return  _dataArry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    //[_tableview registerNib:[UINib nibWithNibName:@"FDTCell" bundle:nil] forCellReuseIdentifier:cellID];
    [_tableview registerClass:[FDTMasoryCell class] forCellReuseIdentifier:cellMasonryID];
    [_tableview registerClass:[JXMasonryCell class] forCellReuseIdentifier:@"JXMasonryCell"];
    [self.view addSubview:_tableview];
    
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       JXMasonryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JXMasonryCell"];
        FDTModel *model = self.dataArry[indexPath.row];
        [cell fill:model];
        return cell;
    }
//
    //FDTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    FDTMasoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMasonryID];
    FDTModel *model = self.dataArry[indexPath.row];
    [cell fill:model];
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"JXMasonryCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            FDTModel *model = self.dataArry[indexPath.row];
            [cell fill:model];
        }];
        
        return height;
    }
    
    return [tableView fd_heightForCellWithIdentifier:cellMasonryID cacheByIndexPath:indexPath configuration:^(id cell) {
        FDTModel *model = self.dataArry[indexPath.row];
        [cell fill:model];
    }];
    
}

@end
