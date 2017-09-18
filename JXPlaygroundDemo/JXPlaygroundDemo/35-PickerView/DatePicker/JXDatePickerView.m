//
//  JXDatePickerView.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/18.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXDatePickerView.h"
#import "UIView+Frame.h"
#import "NSDate+Extension.h"

#define DATERGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define DATERGB(r, g, b) DATERGBA(r,g,b,1)

#define MAXYEAR (2049)
#define MINYEAR (1970)

#define DATENAMES @[@"年",@"月",@"日",@"时",@"分",@"秒"]
#define kPickerSize self.datePicker.frame.size
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

typedef void(^doneBlock)(NSDate *);


@interface JXDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@property (nonatomic, copy) doneBlock doneBlock;

@property (nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic, copy) NSArray <NSNumber *>*showStyle;

@property (nonatomic, strong) NSDate *scrollToDate;//滚到指定日期
@property (nonatomic, strong) NSDate *currentDate; //默认显示时间

@property (nonatomic, assign) NSUInteger maxYear;
@property (nonatomic, assign) NSUInteger minYear;


@property (nonatomic, strong) NSMutableArray <NSString *>*yearArray;
@property (nonatomic, strong) NSArray <NSString *>*monthArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*dayArray;
@property (nonatomic, strong) NSArray <NSString *>*hourArray;
@property (nonatomic, strong) NSArray <NSString *>*minuteArray;
@property (nonatomic, strong) NSArray <NSString *>*secondArray;


@property (nonatomic, assign) NSInteger yearIndex;
@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger dayIndex;
@property (nonatomic, assign) NSInteger hourIndex;
@property (nonatomic, assign) NSInteger minuteIndex;
@property (nonatomic, assign) NSInteger secondIndex;

@end

@implementation JXDatePickerView
#pragma mark - lazy load
- (NSArray<NSString *> *)monthArray{
    if (_monthArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i <= 12; ++i) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        
        _monthArray = array;
    }
    return _monthArray;
}

- (NSArray<NSString *> *)secondArray{
    if (_secondArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 60; ++i) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        
        _secondArray = array;
    }
    return _secondArray;
}

- (NSArray<NSString *> *)minuteArray{
    
    if (_minuteArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 60; ++i) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        
        _minuteArray = array;
    }
    return _minuteArray;
}

- (NSArray<NSString *> *)hourArray{
    if (_hourArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 24; ++i) {
            [array addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        
        _hourArray = array;
    }
    return _hourArray;
}

- (UIPickerView *)datePicker{
    if (_datePicker == nil) {
        _datePicker = [[UIPickerView alloc] initWithFrame:self.yearLabel.bounds];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}


#pragma mark - setter
- (void)setDatePickerStyle:(JXDatePickerStyle)datePickerStyle{
    _datePickerStyle = datePickerStyle;
    NSArray *DateStyleData;
    switch (datePickerStyle) {
        case JXDatePickerStyleShowYearMonthDayHourMinuteSecond:
            DateStyleData = @[@(0), @(1), @(2), @(3), @(4), @(5)];
            break;
        case JXDatePickerStyleShowYearMonthDayHourMinute:
            DateStyleData = @[@(0), @(1), @(2), @(3), @(4)];
            break;
        case JXDatePickerStyleShowYearMonthDay:
            DateStyleData = @[@(0), @(1), @(2)];
            break;
            
        case JXDatePickerStyleShowMonthDayHourMinute:
            DateStyleData = @[@(1), @(2), @(3), @(4)];
            break;
        case JXDatePickerStyleShowMonthDay:
            DateStyleData = @[@(1), @(2)];
            break;
            
        case JXDatePickerStyleShowHourMinuteSecond:
            DateStyleData = @[@(3), @(4), @(5)];
            break;
        case JXDatePickerStyleShowHourMinute:
            DateStyleData = @[@(3), @(4)];
            break;
            
        default:
            DateStyleData = @[];
            break;
    }
    
    [self setShowStyle:DateStyleData];
    
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    
    if (_maxLimitDate && [_maxLimitDate compare:minLimitDate] == NSOrderedAscending) {
        return ;
    }
    
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    
    if (self.minYear < self.minLimitDate.year) {
        self.minYear = self.minLimitDate.year;
        [self defaultConfig];
        
    }else{
        [self scrollToDate:self.scrollToDate animated:YES];
        
    }
}

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    
    if (_minuteIndex && [maxLimitDate compare:_minLimitDate] == NSOrderedAscending) {
        return ;
    }
    
    _maxLimitDate = maxLimitDate;
    if ([_scrollToDate compare:self.maxLimitDate] == NSOrderedDescending) {
        _scrollToDate = self.maxLimitDate;
    }
    
    if (self.maxYear < self.maxLimitDate.year) {
        self.maxYear = self.maxLimitDate.year;
        [self defaultConfig];
        
    }else{
        [self scrollToDate:self.scrollToDate animated:YES];
        
    }
}




- (void)setShowStyle:(NSArray<NSNumber *> *)showStyle{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSNumber *number in showStyle) {
        if (number.integerValue >= 0 && number.integerValue <= 5) {
            [arr addObject:number];
        }
    }
    _showStyle = [arr copy];
    
    [self.datePicker reloadAllComponents];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToDate:self.scrollToDate animated:NO];
    });
}



#pragma mark - Public Method
+ (instancetype)datePickerViewWithCompleteBlock:(void(^)(NSDate *))completeBlock{
    return [self datePickerViewWithCurrentDate:nil CompleteBlock:completeBlock];
}

+ (instancetype)datePickerViewWithCurrentDate:(NSDate *)currentDate CompleteBlock:(void (^)(NSDate *))completeBlock{
     return [self datePickerViewWithCurrentDate:currentDate maxYear:MAXYEAR minYear:MINYEAR CompleteBlock:completeBlock];
}

+ (instancetype)datePickerViewWithCurrentDate:(NSDate *)currentDate maxYear:(NSUInteger)maxYear minYear:(NSUInteger)minYear CompleteBlock:(void (^)(NSDate *))completeBlock{
 
    
     JXDatePickerView *datePickerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    
    if (datePickerView) {
        
        [datePickerView setDatePickerStyle:JXDatePickerStyleShowYearMonthDayHourMinute];
        
        datePickerView.currentDate = currentDate;
        
        if (maxYear <= MAXYEAR && MINYEAR <= minYear && maxYear >= minYear) {
            datePickerView.maxYear = maxYear;
            datePickerView.minYear = minYear;
        }else{
            datePickerView.maxYear = MAXYEAR;
            datePickerView.minYear = MINYEAR;
        }
        
        [datePickerView setupUI];
        [datePickerView defaultConfig];
        
        if (completeBlock) {
            datePickerView.doneBlock = ^(NSDate *date) {
                completeBlock(date);
            };
        }
    }
    
    return datePickerView;
}

/// 滚动到指定时间
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated{
    if (!date) {
        date = [NSDate date];
    }
    
    if ([date compare:self.maxLimitDate] == NSOrderedDescending) {
        date = self.maxLimitDate;
    }else if ([date compare:self.minLimitDate] == NSOrderedAscending){
        date = self.minLimitDate;
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    _yearIndex = date.year - self.minYear;
    _monthIndex = date.month - 1;
    _dayIndex = date.day - 1;
    _hourIndex = date.hour;
    _minuteIndex = date.minute;
    _secondIndex = date.seconds;
    
    NSArray *indexs = @[@(_yearIndex), @(_monthIndex), @(_dayIndex), @(_hourIndex), @(_minuteIndex), @(_secondIndex)];
    
    for (NSUInteger i = 0; i < self.showStyle.count; i ++) {
        
        NSNumber *type = [self.showStyle objectAtIndex:i];
        NSNumber *index = [indexs objectAtIndex:type.integerValue];
        
        [self.datePicker selectRow:index.integerValue inComponent:i animated:animated];
    }
    
    self.yearLabel.text = _yearArray[_yearIndex];
    
    [self.datePicker reloadAllComponents];
}

- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.2 animations:^{
        self.bottomLayoutConstraint.constant = 0;
        self.backgroundColor = DATERGBA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:.2 animations:^{
        self.bottomLayoutConstraint.constant = - self.jx_height;
        self.backgroundColor = DATERGBA(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}


#pragma mark - Private Method
- (void)setupUI{
    
    self.bottomView.layer.masksToBounds = YES;
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    self.bottomLayoutConstraint.constant = - self.bottomView.jx_height;
    self.backgroundColor = DATERGBA(0, 0, 0, 0);
    
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    [self.yearLabel addSubview:self.datePicker];
    
    self.datePicker.frame = self.yearLabel.bounds;
    self.datePicker.jx_height = 180.0;
    self.datePicker.center = CGPointMake(self.yearLabel.jx_width * 0.5, self.yearLabel.jx_height * 0.5);
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
}


- (void)defaultConfig{
    
    self.themeColor = DATERGB(247, 133, 51);
    
    
    _yearArray = nil;
    _dayArray = nil;
    //设置年月日时分数据
    _yearArray = [NSMutableArray array];
    _dayArray = [NSMutableArray array];
    
    _scrollToDate = (self.currentDate != nil)? self.currentDate : [NSDate date];
    
    for (NSInteger i = self.minYear; i <= self.maxYear; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:[NSString stringWithFormat:@"%ld-12-31 23:59", self.maxYear] WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:[NSString stringWithFormat:@"%ld-01-01 00:00", self.minYear] WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    
    [self scrollToDate:self.currentDate animated:YES];
    
}


//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isRunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self configDayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self configDayArray:30];
            return 30;
        }
        case 2:{
            if (isRunNian) {
                [self configDayArray:29];
                return 29;
            }else{
                [self configDayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

- (void)configDayArray:(NSInteger)num{
    [_dayArray removeAllObjects];
    for (int i = 1; i <= num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

/// 增加年月日时分秒Label
- (void)addLabelWithName:(NSArray *)nameArr {
    
    for (id subView in self.yearLabel.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < nameArr.count; i ++) {
        
        CGFloat labelX = kPickerSize.width / (nameArr.count * 2) + 18 + kPickerSize.width / nameArr.count * i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, (self.yearLabel.frame.size.height - 15)/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = self.themeColor;
        label.backgroundColor = [UIColor clearColor];
        [self.yearLabel addSubview:label];
    }
}



#pragma mark - Actions
- (IBAction)done:(UIButton *)sender {
    
    if (self.doneBlock) {
        self.scrollToDate ? self.doneBlock(self.scrollToDate) : self.doneBlock([NSDate date]);
    }
    self.doneBlock = nil;
    [self dismiss];
    
}

- (IBAction)cancel:(UIButton *)sender {
    self.doneBlock = nil;
    [self dismiss];
}



#pragma mark - UIPickerViewDataSource/UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for (NSNumber *number in self.showStyle) {
        [mutableArray addObject:[DATENAMES objectAtIndex:number.integerValue]];
    }
    
    [self addLabelWithName:mutableArray];
    
    return self.showStyle.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = self.monthArray.count;
    NSInteger hourNum = self.hourArray.count;
    NSInteger minuteNum = self.minuteArray.count;
    NSInteger secondNum = self.secondArray.count;
    
    NSUInteger year = [_yearArray[_yearIndex] integerValue];
    NSUInteger month = [self.monthArray[_monthIndex] integerValue];
    
    NSInteger dayNum = [self DaysfromYear:year andMonth:month];
    
    NSArray *allNum = @[@(yearNum), @(monthNum), @(dayNum), @(hourNum), @(minuteNum), @(secondNum)];
    
    
    //component  更新不及时 会越界
    if (component < self.showStyle.count) {
        NSNumber *number = [self.showStyle objectAtIndex:component];
        return [[allNum objectAtIndex:number.integerValue] integerValue];
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        customLabel.font = [UIFont systemFontOfSize:17];
        customLabel.textColor = [UIColor blackColor];
    }
    
    NSArray *allTitles = @[_yearArray, self.monthArray, _dayArray, self.hourArray, self.minuteArray, self.secondArray];
    NSNumber *number = [self.showStyle objectAtIndex:component];
    
    NSArray *titles = [allTitles objectAtIndex:number.integerValue];
    
    NSString *title = [titles objectAtIndex:row];
    
    customLabel.text = title;
    
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSNumber *number = [self.showStyle objectAtIndex:component];
    
    switch (number.integerValue) {
        case 0:
            _yearIndex = row;
            break;
        case 1:
            _monthIndex = row;
            break;
        case 2:
            _dayIndex = row;
            break;
        case 3:
            _hourIndex = row;
            break;
        case 4:
            _minuteIndex = row;
            break;
        case 5:
            _secondIndex = row;
            break;
            
        default:
            break;
    }
    
    self.yearLabel.text = _yearArray[_yearIndex];
    
    if (number.integerValue == 0 || number.integerValue == 1){
        [self DaysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
        if (_dayArray.count - 1 < _dayIndex) {
            _dayIndex = _dayArray.count - 1;
        }
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",_yearArray[_yearIndex], _monthArray[_monthIndex], _dayArray[_dayIndex], _hourArray[_hourIndex], _minuteArray[_minuteIndex], _secondArray[_secondIndex]];
    
    self.scrollToDate = [NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self scrollToDate:self.scrollToDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self scrollToDate:self.scrollToDate animated:YES];
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判定一个视图是否在其父视图的视图层中
    if( [touch.view isDescendantOfView:self.bottomView]) {
        return NO;
    }
    return YES;
}


@end
