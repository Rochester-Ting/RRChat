//
//  RRLoginVC.m
//  RRChat
//
//  Created by 丁瑞瑞 on 5/8/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRLoginVC.h"
#import "EaseMob.h"
#import "SVTools.h"
#import "RRTabBarVC.h"
#import "RRHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface RRLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;

@end

@implementation RRLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 登陆
- (IBAction)loginBtnClick:(UIButton *)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.accountText.text password:self.passWordText.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
            // 设置自动登录的状态
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            [RRHUD showSuccess:@"登陆成功!"];
            // 登陆成功以后跳转界面
            RRTabBarVC *tabBarVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            // 添加子控制器
            [self addTabBarChildVCParentVC:tabBarVC withChildVC:@"ChatListVC"];
            [self addTabBarChildVCParentVC:tabBarVC withChildVC:@"FriendsVC"];
            [self addTabBarChildVCParentVC:tabBarVC withChildVC:@"MeVC"];
            
            self.view.window.rootViewController = tabBarVC;
            
        }else{
            NSLog(@"error ==== %@",error);
        }
    } onQueue:nil];
}
- (void)addTabBarChildVCParentVC:(RRTabBarVC *)vc withChildVC:(NSString *)name{
    UIViewController *childVC = [UIStoryboard storyboardWithName:name bundle:nil].instantiateInitialViewController;
    
    [vc addChildViewController:childVC];
}
#pragma mark - 注册
- (IBAction)registerBtnClick:(UIButton *)sender {
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.accountText.text password:self.passWordText.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            [RRHUD showSuccess:@"注册成功!"];
        }else{
            [RRHUD showError:@"注册失败!"];
            NSLog(@"%@",error);
        }
    } onQueue:nil];
}
@end
