//
//  JXPopupViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPopupViewController.h"
#import "JXPopupView.h"
#import "JXPopupInnerView.h"
#import <CNPPopupController.h>

@interface JXPopupViewController ()<CNPPopupControllerDelegate>

@property(nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation JXPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"26-弹出视图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datas = @[
                   @"效果1 -- JXPopupView",
                   @"效果2 -- CNPPopupController"
                   ];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self showPopupView];
            break;
            
        case 1:
            [self showPopupCentered];
            break;
            
        default:
            break;
    }
}







- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"It's A Popup!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"You can add text and images" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Close Me" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button.layer.cornerRadius = 4;
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
    
    UILabel *lineTwoLabel = [[UILabel alloc] init];
    lineTwoLabel.numberOfLines = 0;
    lineTwoLabel.attributedText = lineTwo;
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 55)];
    customView.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 35)];
    textFied.borderStyle = UITextBorderStyleRoundedRect;
    textFied.placeholder = @"Custom view!";
    [customView addSubview:textFied];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, imageView, lineTwoLabel, customView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}




- (void)showPopupView{
    JXPopupInnerView *view = [JXPopupInnerView defaultPopupView];
    view.parentVC = self;
    view.selIndex = 3;
    
    view.contents = @[
                      @"拍多",
                      @"拍错拍错拍错",
                      @"质量不好",
                      @"商品不符合",
                      @"描述不一样"
                      ];
    
    [view setSelectCompletion:^(NSString *content, NSInteger index){
        
        NSLog(@"content == %@ index == %ld",content,index);
    }];
    
    JXPopupViewAnimationSlide *animation = [[JXPopupViewAnimationSlide alloc]init];
    animation.type = JXPopupViewAnimationSlideTypeBottomBottom;
    [self jx_presentPopupView:view animation:animation dismissed:^{
        NSLog(@"动画结束");
    }];
}


#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

#pragma mark - event response

-(void)showPopupCentered {
    [self showPopupWithStyle:CNPPopupStyleCentered];
}

- (void)showPopupFormSheet{
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
}

- (void)showPopupFullscreen{
    [self showPopupWithStyle:CNPPopupStyleFullscreen];
}



@end
