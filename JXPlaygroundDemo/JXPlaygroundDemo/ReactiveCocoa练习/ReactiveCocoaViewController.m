//
//  ReactiveCocoaViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//
#pragma mark - *********** ReactiveCocoa中的类
#pragma mark 信号类(RACSiganl) --> 核心类

/*！
 // RACSignal使用步骤：
 // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
 // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
 // 3.发送信号 - (void)sendNext:(id)value
 
 */

/*!
 // RACSignal底层实现：
 // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
 // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
 // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
 // 2.1 subscribeNext内部会调用siganl的didSubscribe
 // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
 // 3.1 sendNext底层其实就是执行subscriber的nextBlock
 */


#pragma mark - RACSubscriber
/*！
 6.2 RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。
 */


#pragma mark - RACDisposable
/*！
RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
 
 使用场景:不想监听某个信号时，可以通过它主动取消订阅信号。
 */


#pragma mark - RACSubject
/*！
 
 RACSubject:信号提供者，自己可以充当信号，又能发送信号。
 
 使用场景:通常用来代替代理，有了它，就不必要定义代理了。
 
 */


#pragma mark - RACReplaySubject
/*！
 RACReplaySubject:重复提供信号类，RACSubject的子类。
 RACReplaySubject与RACSubject区别:
 RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
 使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
 
 使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
 
 */


#pragma mark - RACTuple
/*！
RACTuple:元组类,类似NSArray,用来包装值.
 */


#pragma mark - RACSequence
/*！
 RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
 使用场景：1.字典转模型
 */


#pragma mark - RACCommand
/*！
RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程
 
 使用场景:监听按钮点击，网络请求
 
 RACCommand简单使用:
 
 */

#pragma mark - ********* ReactiveCocoa开发中常见用法。
/**!
 7.1 代替代理:
 rac_signalForSelector：用于替代代理。
 
 7.2 代替KVO :
 rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
 
 7.3 监听事件:
 rac_signalForControlEvents：用于监听某个事件。
 
 7.4 代替通知:
 rac_addObserverForName:用于监听某个通知。
 
 7.5 监听文本框文字改变:
 rac_textSignal:只要文本框发出改变就会发出这个信号。
 
 7.6 处理当界面有多次请求时，需要都获取到数据时，才能展示界面
 rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。

 
 */





#import "ReactiveCocoaViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FlagItem.h"
#import "ReativeSearchViewController.h"

@interface ReactiveCocoaViewController ()

@property(nonatomic, strong) UITextField *textF1;
@property(nonatomic, strong) UITextField *textF2;
@property(nonatomic, strong) UITextField *textF3;
@property(nonatomic, strong) UIButton *btn;


@property(nonatomic, strong) RACSignal *usernameSignal;
@property(nonatomic, strong) RACSignal *passwordSignal;
@property(nonatomic, strong) RACSignal *comfirmSignal;


@property(nonatomic, strong) RACCommand *conmmand;

@end

@implementation ReactiveCocoaViewController


#pragma mark - lazy loading
- (UITextField *)textF1{
    if (_textF1 == nil) {
        _textF1 = [[UITextField alloc]initWithFrame:CGRectMake(10, 60, 100, 30)];
        _textF1.placeholder = @"账号";
       
    }
    return _textF1;
}

- (UITextField *)textF2{
    if (_textF2 == nil) {
        _textF2 = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 100, 30)];
        _textF2.placeholder = @"密码";
       
    }
    return _textF2;
}


- (UITextField *)textF3{
    if (_textF3 == nil) {
        _textF3 = [[UITextField alloc]initWithFrame:CGRectMake(10, 150, 100, 30)];
        _textF3.placeholder = @"确定密码";
        
    }
    return _textF3;
}


- (UIButton *)btn{
    
    if (_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"注册" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            [self.navigationController pushViewController:[[ReativeSearchViewController alloc]init] animated:YES];
        }];
        [_btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _btn.frame = CGRectMake(10, 190, 100, 30);
    }
    return _btn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self test_Noti];
    [self.view addSubview:self.textF1];
    [self.view addSubview:self.textF2];
    [self.view addSubview:self.textF3];
    [self.view addSubview:self.btn];
    
    
    [self confirm1];
    [self confirm2];
    [self confirm3];
    [self confirm4];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self test_KVO];
    
//    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataArray];
    
    [self kaifa];
}





#pragma mark - 验证
- (void)confirm4{
    
    // 绑定用户名、密码、确认密码判断结果的三个信号量，如果三个都为真，则按钮可用
    RAC(self.btn, enabled) = [RACSignal combineLatest:@[_usernameSignal, _passwordSignal, _comfirmSignal] reduce:^(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect, NSNumber *isComfirmCorrect){
        
        return @(isUsernameCorrect.boolValue && isPasswordCorrect.boolValue && isComfirmCorrect.boolValue);
    }];
}

// 案例一：登录或注册时的输入基本验证
- (void)confirm1{
    
    // 设置用户名是否合法的信号
    // map用于改变信号返回的值，在信号中判断后，返回bool值
    _usernameSignal = [self.textF1.rac_textSignal map:^id(NSString *usernameText) {
        
        NSUInteger length = usernameText.length;
        
        if (length >= 1 && length <= 6) {
            return @(YES);
        }
        return @(NO);
    }];
}

- (void)confirm2{
    
    // 设置密码是否合法的信号
    // map用于改变信号返回的值，在信号中判断后，返回bool值
    _passwordSignal = [self.textF2.rac_textSignal map:^id(NSString *usernameText) {
        
        NSUInteger length = usernameText.length;
        
        if (length >= 1 && length <= 16) {
            return @(YES);
        }
        return @(NO);
    }];
}

/// 判断确认密码是否合法
- (void)confirm3{
    // 设置确认密码合法的信号
    // 因为确认密码的文本要和密码的文本有关联，无论确认密码修改还是密码修改，都需要及时判断，所以需要绑定两个信号量
    _comfirmSignal = [RACSignal combineLatest:@[self.textF2.rac_textSignal, self.textF3.rac_textSignal] reduce:^id(NSString *passwordText, NSString *comfirmText){
        
        NSUInteger length = comfirmText.length;
        
        if (length >= 1 && [comfirmText isEqualToString:passwordText]) {
            return @(YES);
        }
        return @(NO);
    }];
}




/*!
 注意: RAC中的通知不需要remove observer，因为在rac_add方法中他已经写了remove。
 */

/// 通知
- (void)test_Noti{
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification *notification) {
        NSLog(@"%@", notification.name);
        NSLog(@"%@", notification.object);
    }];
    
}

/// KVO
- (void)test_KVO{
    
    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    scrolView.contentSize = CGSizeMake(200, 800);
    scrolView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrolView];
    [RACObserve(scrolView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"success");
    }];

}

- (void)test3{
    
    // 3.字典转模型
    // 3.1 OC写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSDictionary *dict in dictArr) {
        FlagItem *item = [FlagItem flagWithDict:dict];
        [items addObject:item];
    }
    
    
    
    // 3.2 RAC写法
//    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
//    NSArray *dictArr1 = [NSArray arrayWithContentsOfFile:filePath1];
    
    NSMutableArray *flags = [NSMutableArray array];
    

    
    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        // 运用RAC遍历字典，x：字典
        
        FlagItem *item = [FlagItem flagWithDict:x];
        
        [flags addObject:item];
        
    }];
    
    NSLog(@"%@",  NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    
    // 3.3 RAC高级写法:
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags2 = [[dictArr.rac_sequence map:^id(id value) {
        
        return [FlagItem flagWithDict:value];
        
    }] array];
    
    
}

- (void)test1{
    
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}

- (void)test2{
    
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"key=%@ value=%@",key,value);
        
    }];
}


#pragma mark -  ********* RACCommand使用
/**!
 使用场景:监听按钮点击，网络请求
 */
- (void)RACCommand_USE{
    
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        NSLog(@"执行命令");
        
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _conmmand = command;
    
    
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
        }];
        
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令
    [self.conmmand execute:@1];
    
    
    
}


#pragma mark - ******  开发中常见用法代码演示
- (void)kaifa{
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[self.btn rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[self.view rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    // 5.监听文本框的文字改变
    [self.textF1.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    
    
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - ******* ReactiveCocoa常见宏。
- (void)hong{
    
    // 8.1 RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    
    // 只要文本框文字改变，就会修改label的文字
//    RAC(self.labelView,text) = _textField.rac_textSignal;
    
    
    
   // 8.2 RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    // 8.3  @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。
    
    
    // 8.4 RACTuplePack：把数据包装成RACTuple（元组类）
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10,@20);
    
    
   // 8.5 RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
    
    // 把参数中的数据包装成元组
    RACTuple *tuple1 = RACTuplePack(@"xmg",@20);
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"xmg" age = @20
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple1;
    
    
    
}

@end
