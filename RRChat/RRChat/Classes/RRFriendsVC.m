//
//  RRFriendsVC.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRFriendsVC.h"
#import "RRAddFriendsVC.h"
#import "RRNoticeVC.h"
#import "EaseMob.h"
#import "RRNoticeArr.h"
#import "RRHUD.h"
#import "RRChatViewController.h"
@interface RRFriendsVC ()<EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notice;
/** <#注释#>*/

@end

@implementation RRFriendsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([RRNoticeArr sharenotice].notice.count != 0) {
        [self.notice setTitle:@"notice"];
    }else{
        [self.notice setTitle:@"通知"];
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    // 先从本地数据库获取好友列表,APP启动时从服务器获取好友列表,所以只需要从本地数据库获取好友列表
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    self.buddyList = buddyList;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BudyList"];
}
- (IBAction)addFriends:(id)sender {
    RRAddFriendsVC *addFriendsVC = [[RRAddFriendsVC alloc] init];
    [self.navigationController pushViewController:addFriendsVC animated:YES];
}
- (IBAction)noticeBtnClick:(id)sender {
    RRNoticeVC *noticeVC = [[RRNoticeVC alloc] init];
    [self.navigationController pushViewController:noticeVC animated:YES];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buddyList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BudyList"];
    EMBuddy *buddy = self.buddyList[indexPath.row];
    cell.textLabel.text = buddy.username;
    return cell;
}
#pragma mark - 被好友删除
- (void)didRemovedByBuddy:(NSString *)username{
    [self updateBuddyList];
}
#pragma mark - 好友接受请求
- (void)didAcceptBuddySucceed:(NSString *)username{
    [self updateBuddyList];
}
#pragma mark - 代理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    EMBuddy *buddy = self.buddyList[indexPath.row];
    EMError *error = nil;
    // 删除好友
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
    if (isSuccess && !error) {
        NSLog(@"删除成功");
        [RRHUD showSuccess:@"删除成功!"];
        [self updateBuddyList];
        
    }
}
#pragma mark - tableView的代理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    RRChatViewController *chatVC = [UIStoryboard storyboardWithName:@"ChatViewController" bundle:nil].instantiateInitialViewController;
    EMBuddy *buddy = self.buddyList[indexPath.row];
    chatVC.username = buddy.username;
    chatVC.buddy = buddy;
    [self.navigationController pushViewController:chatVC animated:YES];
}
#pragma mark - 从服务器获取好友列表
- (void)updateBuddyList{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功 -- %@",buddyList);
            self.buddyList = buddyList;
            [self.tableView reloadData];
        }
    } onQueue:nil];
}
#pragma mark - 移除代理
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
