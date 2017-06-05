//
//  JXNotificationViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXNotificationViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface JXNotificationViewController ()<UNUserNotificationCenterDelegate>

@property(nonatomic, strong) NSTimer *timer;
@end

/**!
 步骤：
 1.给APP申请通知权限，
 2.读取用户对通知的设置；
 3.创建定时器；
 4.添加通知中心观察者；
 5.创建 UNUserNotificationCenter对象，配置推送内容；
 6.分别处理前台和后台接收通知的情况；
 7.用户点击通知后的界面跳转；
 8.移除定时器、通知中心对象。
 
 */

@implementation JXNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*! 1.给APP申请通知权限 */
    // 1.给APP申请通知权限,关于请求权限(定位等)务必放在APPdelegate中,程序一启动马上提醒用户选择.否则设置-通知中心根本就没有此应用程序的通知设置,自己想去后台设置打开都找不到地方。
    // 这是iOS10请求通知权限的API
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // 用户对通知的设置
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            JXLog(@"%@", (long)settings.authorizationStatus == 2 ? @"成获取到通知权限" : @"用户关闭了通知");
            if (settings.authorizationStatus != 2) {
                JXLog(@"用户关闭了通知");
            }
        }];
    }];
    
    
    // ...
    if ([self isPermissionedPushNotification])
    {
        NSTimeInterval RequestTimeInterval = 3;
        
        /*! 3.创建定时器，获得新消息未读数 */
        self.timer = [NSTimer scheduledTimerWithTimeInterval:RequestTimeInterval target:self selector:@selector(setupUnreadTradeMsg) userInfo:nil repeats:YES];
        // 设置timer模式
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    /*! 4.创建通知中心观察者 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmReadNoticeContent:) name:@"ReadNoticeContent" object:nil];
}

// 定时器执行方法
- (void)setupUnreadTradeMsg{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NetworkEngine signPostWithURL:PARAMQUERY parmas:params success:^(id requestResult) {
            // ...
            // 省略部分网络请求代码
            
            // 设置app角标数量 = 未读消息数量
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
            // 消息按钮红点
//            [self.msgBtn setBackgroundImage:[UIImage imageNamed:@"new_message"] forState:UIControlStateNormal];
            // 将新的交易信息内容传入推送
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            // ...
            // 发起推送
            [self pushNotificationOfTradeMsg:params];
//        } failure:^(NSError *error) {
//            // [self showToast:@"请求失败,请检查网络连接"];
//            return ;
//        }];
    });
    
}


/*! 2.检查用户对通知功能的设置状态 */
// 2.检查用户对通知功能的设置状态，我放在首页viewDidLoad中，当用户一进入首页如果发现没有打开则以弹窗的形式提醒用户，引导其打开；否则不进行接下来的操作。注：以下代码都放在首页控制器中。
- (BOOL)isPermissionedPushNotification {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        JXLog(@"用户关闭了通知功能");
        // 弹窗
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:@"请打开通知功能,否则无法收到交易提醒." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JXLog(@"引导用户去设置中心打开通知");
            // 点击跳转至设置中心
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略交易提醒" style:UIAlertActionStyleCancel handler:nil];
        
        [alertvc addAction:cancelAction];
        [alertvc addAction:confirmAction];
        [self presentViewController:alertvc animated:YES completion:nil];
        
        return false;
    } else {
        JXLog(@"可以进行推送");
        return true;
    }
}



/*! 5.配置推送内容 */
- (void)pushNotificationOfTradeMsg:(NSDictionary *)params {
    // 1、创建通知对象
    UNUserNotificationCenter *center  = [UNUserNotificationCenter currentNotificationCenter];
    // 必须设置代理，否则无法收到通知
    center.delegate = self;
    // 权限
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 2、创建通知内容
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            // 标题
            content.title = params[@"title"];
            content.body = params[@"content"];
            // 声音
            content.sound = [UNNotificationSound soundNamed:@"notification.wav"];
            // 图片
            NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"msgImg" withExtension:@"png"];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
            content.attachments = @[attachment];
            // 标识符
            content.categoryIdentifier = @"categoryIndentifier";
            
            // 3、创建通知触发时间
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
            // 4、创建通知请求
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
            // 5、将请求加入通知中心
            [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    JXLog(@"已成功加入通知请求");
                } else {
                    JXLog(@"出错啦%@", [error localizedDescription]);
                }
            }];
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate
/*! 6.分别处理前台和后台接收通知的情况 */
/** 6.1当用户处于前台时,消息发送前走这个方法 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    JXLog(@"--------通知即将发出-------");
    // 在前台时,通过此方法监听到消息发出,不让其在通知栏显示,以弹窗的形式展示出来;设置声音提示
    completionHandler(UNNotificationPresentationOptionSound);
    
    // 获取消息内容
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content setObject:notification.request.content.title forKey:@"content"];
    [content setObject:notification.request.content.body forKey:@"body"];
    
    // 弹窗
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:notification.request.content.title message:notification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* updateAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 创建通知对象
        NSNotification *notice = [NSNotification notificationWithName:@"ReadNoticeContent" object:nil userInfo:content];
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        JXLog(@"点击查看消息");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
    [alertvc addAction:cancelAction];
    [alertvc addAction:updateAction];
    [self presentViewController:alertvc animated:YES completion:nil];
}


/** 6.2不处于前台时,与通知交互走这个方法 */
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
    // 获取消息内容
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content setObject:response.notification.request.content.title forKey:@"content"];
    [content setObject:response.notification.request.content.body forKey:@"body"];
    
    // 判断是否为本地通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"收到远程通知");
    } else {
        // 判断为本地通知
        //创建通知对象
        NSNotification *notice = [NSNotification notificationWithName:@"ReadNoticeContent" object:nil userInfo:content];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    }
}

/*! 7.用户点击通知后的界面跳转 */
// 点击查看消息，进行界面跳转
- (void)confirmReadNoticeContent:(NSDictionary *)content {
    JXLog(@"跳转页面 %@", content);
    
    // 点击通知查看内容，角标清零,红点消失
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [self.msgBtn setBackgroundImage:[UIImage imageNamed:@"nav_message"] forState:UIControlStateNormal];
    
    /*!
    // 获取当前跟控制器
    UIViewController *rootVC = nil;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    if ([window.rootViewController isKindOfClass:[GFNavigationController class]])
    {
        rootVC = [(GFNavigationController *)window.rootViewController visibleViewController];
    }
    else if ([window.rootViewController isKindOfClass:[GFTabBarController class]])
    {
        GFTabBarController *tabVC = (GFTabBarController *)window.rootViewController;
        rootVC = [(GFNavigationController *)[tabVC selectedViewController] visibleViewController];
    }
    else
    {
        rootVC = window.rootViewController;
    }
    
    // 跳转到消息列表页面
    TradeMessageViewController *tmvc = [[TradeMessageViewController alloc] init];
    [rootVC.navigationController pushViewController:tmvc animated:YES];
     */
}

/*! 8.移除定时器、通知中心对象 */
- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 销毁定时器
    [self.timer invalidate];
    self.timer = nil;
}


@end
