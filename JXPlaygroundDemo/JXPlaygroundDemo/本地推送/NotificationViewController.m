//
//  NotificationViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "NotificationViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "JXNotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"本地通知";
    
    
    // 本地通知一
//    [self requestLocationNotification1];
    
    // 本地通知二
    [self requestLocationNotification2];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"通知2" style:UIBarButtonItemStylePlain target:self action:@selector(noti2Action)];
    
}


- (void)noti2Action{
    [self.navigationController pushViewController:[[JXNotificationViewController alloc]init] animated:YES];
}

- (void)requestLocationNotification1{
    // 1.创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"iOS_Icon测试通知";
    // 推送内容的子标题
    content.subtitle = @"测试通知";
    content.body = @"来自iOS_Icon的简书";
    content.badge = @1;
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_certification_status1@2x" ofType:@"png"];
    
    // 2.设置通知附件内容
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        JXLog(@"attachment error %@", error);
    }
    content.attachments = @[att];
    // app通知下拉预览时候展示的图
    content.launchImageName = @"2";
    
    // 2.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    
    // UNNotificationSound类，可以设置默认声音，或者指定名称的声音
    content.sound = sound;
    
    // 3.触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    // 4.设置UNNotificationRequest
    NSString *requestIdentifer = @"TestRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];

}

- (void)requestLocationNotification2{
    
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"iOS_Icon测试通知";
    content.subtitle = @"测试通知";
    content.body = @"来自iOS_Icon的简书";
    content.badge = @1;
    
    NSError *error = nil;
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_certification_status1@2x" ofType:@"png"];
    
     // 1.gif图的路径
     NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"gif"];
     //  2.mp4的路径
     //    NSString *path = [[NSBundle mainBundle] pathForResource:@"flv视频测试用例1" ofType:@"mp4"];
     
     
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     
     
     //附件通知键值使用说明
    // 1.UNNotificationAttachmentOptionsTypeHintKey
     // dict[UNNotificationAttachmentOptionsTypeHintKey] = (__bridge id _Nullable)(kUTTypeImage);
    
    
     
     //2.UNNotificationAttachmentOptionsThumbnailHiddenKey
     dict[UNNotificationAttachmentOptionsThumbnailHiddenKey] =  @YES;
     
     //3.UNNotificationAttachmentOptionsThumbnailClippingRectKey
     dict[UNNotificationAttachmentOptionsThumbnailClippingRectKey] = (__bridge id _Nullable)((CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 1 ,1))));
    
     //Rect对应的意思
    /*!
     thumbnailClippingRect =    {
     Height = "0.1";
     Width = "0.1";
     X = 0;
     Y = 0;
     };
     */
     //4. UNNotificationAttachmentOptionsThumbnailTimeKey-选取影片的某一秒做推送显示的缩略图
     dict[UNNotificationAttachmentOptionsThumbnailTimeKey] =@10;
     
     
     
     UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
     if (error) {
     NSLog(@"attachment error %@", error);
     }
     content.attachments = @[att];
     content.launchImageName = @"icon_certification_status1@2x.png";
     
     //这里设置category1， 是与之前设置的category对应
     content.categoryIdentifier = @"category1";
     
     UNNotificationSound *sound = [UNNotificationSound defaultSound];
     content.sound = sound;
     
     
     
     
     /*触发模式1*/
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    /*触发模式2*/
    UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    /*触发模式3*/
    // 周一早上 8：00 上班
    NSDateComponents *components = [[NSDateComponents alloc] init];
    // 注意，weekday是从周日开始的，如果想设置为从周一开始，大家可以自己想想~
    components.weekday = 2;
    components.hour = 8;
    UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    
    
    /*触发模式4 这个方法一般要先#import<CoreLocation/CoreLocation.h>*/
    
    /*这个触发条件一般在
     //1、如果用户进入或者走出某个区域会调用下面两个方法
     - (void)locationManager:(CLLocationManager *)manager
     didEnterRegion:(CLRegion *)region
     - (void)locationManager:(CLLocationManager *)manager
     didExitRegion:(CLRegion *)region代理方法反馈相关信息
     */
    
    CLRegion *region = [[CLRegion alloc] init];
    CLCircularRegion *circlarRegin = [[CLCircularRegion alloc] init];
    
    
    
    
    // 创建本地通知
    NSString *requestIdentifer = @"TestRequestww1";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger1];
    
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
    
}


@end
