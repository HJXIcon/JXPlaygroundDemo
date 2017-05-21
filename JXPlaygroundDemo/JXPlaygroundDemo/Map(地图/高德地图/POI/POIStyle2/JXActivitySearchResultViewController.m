//
//  JXActivitySearchResultViewController.m
//  FishingWorld
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import "JXActivitySearchResultViewController.h"


@interface JXActivitySearchResultViewController ()

@property (nonatomic, strong) NSMutableArray *searchPoiArray;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end
@implementation JXActivitySearchResultViewController

- (NSMutableArray *)searchPoiArray
{
    if (_searchPoiArray == nil)
    {
        _searchPoiArray = [[NSMutableArray alloc] init];
    }
    return _searchPoiArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}


#pragma mark - AMapSearchDelegate
/**
 * @brief POI查询回调函数
 * @param request  发起的请求，具体字段参考 AMapPOISearchBaseRequest 及其子类。
 * @param response 响应结果，具体字段参考 AMapPOISearchResponse 。
 */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    JXLog(@"response.pois == %@",response.pois);
    

    [self.searchPoiArray removeAllObjects];

    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [self.searchPoiArray addObject:obj];
    }];
    
    self.selectedIndexPath = nil;
    [self.tableView reloadData];
}


/**
 * @brief 当请求发生错误时，会调用代理的此方法.
 * @param request 发生错误的请求.
 * @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    JXLog(@"%@",error.description);
}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchPoiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedIndentifier = @"reusedIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIndentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedIndentifier];
    }
        AMapPOI *poi = self.searchPoiArray[indexPath.row];
        cell.textLabel.text = poi.name;
        cell.detailTextLabel.text = poi.address;
    
    if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath;
    
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
