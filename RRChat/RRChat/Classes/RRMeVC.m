//
//  RRMeVC.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRMeVC.h"
#import "EaseMob.h"
#import "RRHUD.h"
#import "RRLoginVC.h"
@interface RRMeVC ()

@property (weak, nonatomic) IBOutlet UIButton *exit;

@end

@implementation RRMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)exitClick:(UIButton *)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
            [RRHUD showSuccess:@"退出成功!"];
            NSUserDefaults *notice = [NSUserDefaults standardUserDefaults];
            NSString *str = [notice objectForKey:@"notice"];
            if ([str isEqualToString:@"YES"]) {
                [notice removeObjectForKey:@"notice"];
                self.navigationController.tabBarItem.badgeValue = nil;
            }

            self.view.window.rootViewController = [[RRLoginVC alloc] init];
        }else{
            [RRHUD showError:@"退出失败!"];
        }
    } onQueue:nil];
}
@end
