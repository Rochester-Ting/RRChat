//
//  RRAddFriendsVC.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRAddFriendsVC.h"
#import "EaseMob.h"
#import "RRHUD.h"
@interface RRAddFriendsVC ()<EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@end

@implementation RRAddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
#pragma mark - 添加好友
- (IBAction)addContacts:(id)sender {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:self.nameText.text message:@"我想加您为好友" error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
        [RRHUD showSuccess:@"发送成功!"];
    }else{
        NSLog(@"----%@",error);
        [RRHUD showError:@"发送失败!"];
    }
}
#pragma mark - 移除代理
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


@end
