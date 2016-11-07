//
//  AppDelegate.m
//  RRChat
//
//  Created by 丁瑞瑞 on 5/8/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "RRLoginVC.h"
#import "RRTabBarVC.h"
#import <SVProgressHUD.h>
#import "SVTools.h"
#import "RRHUD.h"
@interface AppDelegate ()<EMChatManagerDelegate>
/** <#注释#>*/
@property (nonatomic,strong) UIViewController *childVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //registerSDKWithAppKey: 注册的AppKey，详细见下面注释。
    //apnsCertName: 推送证书名（不需要加后缀），详细见下面注释。
    // 初始化SDK
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"dingrui123#rrchatdemo" apnsCertName:@""];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    // 设置代理,监听自动登陆的状态
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    // app启动自动从服务器获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 进入注册界面
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        // 登陆成功以后跳转界面
        RRTabBarVC *tabBarVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        // 添加子控制器
        [self addTabBarChildVCParentVC:tabBarVC withChildVC:@"ChatListVC"];
        [self addTabBarChildVCParentVC:tabBarVC withChildVC:@"FriendsVC"];
        [self addTabBarChildVCParentVC:tabBarVC withChildVC:@"MeVC"];
        
        self.window.rootViewController = tabBarVC;
    }else{
        self.window.rootViewController = [[RRLoginVC alloc] init];
    }
    
    
    [self.window makeKeyAndVisible];
    

    return YES;
}
- (void)addTabBarChildVCParentVC:(RRTabBarVC *)vc withChildVC:(NSString *)name{
    UIViewController *childVC = [UIStoryboard storyboardWithName:name bundle:nil].instantiateInitialViewController;
//    if ([name isEqualToString:@"FriendsVC"]) {
//        self.childVC = childVC;
//    }else{
////        self.childVC = nil;
//    }
    
    [vc addChildViewController:childVC];
}
// 用户自动登陆后的回调
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {
        [RRHUD showSuccess:@"自动登陆成功!"];
    }else{
        NSString *er = [NSString stringWithFormat:@"%@",error];
        [RRHUD showError:er];
    }
}
// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}


@end
