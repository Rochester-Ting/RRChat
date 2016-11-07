//
//  RRChatListVC.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRChatListVC.h"
#import "EaseMob.h"
#import <SVProgressHUD.h>
#import "SVTools.h"
#import "RRHUD.h"
#import "RRNoticeArr.h"
#import "RRChatViewController.h"
#import "RRListCell.h"
@interface RRChatListVC ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** <#注释#>*/
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation RRChatListVC
static NSString *cellId = @"chatListCell";
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTable];
    [self addEaseMobDelegate];
    // 获取历史聊天列表
    [self loadAllConversations];
    // 显示未读消息数
    [self ShowTabBarItemBadge];
}
#pragma mark - addEaseMobDelegate
- (void)addEaseMobDelegate{
    // 监听手机的网络状态
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
#pragma mark - 获取历史聊天列表
- (void)loadAllConversations{
    NSArray *listConversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
//    [self.dataSource addObjectsFromArray:listConversations];
    self.dataSource = listConversations;
}
#pragma mark - 设置tableview
- (void)setTable{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}
#pragma mark - tableview数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    EMConversation *conversation = self.dataSource[indexPath.row];
    // 获取未读的消息数量
    NSUInteger unreadCount = [conversation unreadMessagesCount];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 未读消息数:%zd",conversation.chatter,unreadCount] ;
    
    id msgBody = conversation.latestMessage.messageBodies[0];
    if ([msgBody isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
        cell.detailTextLabel.text = textBody.text;
    }else if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]){
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)msgBody;
        cell.detailTextLabel.text = voiceBody.displayName;
    }else if ([msgBody isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *imageBody = (EMImageMessageBody *)msgBody;
        cell.detailTextLabel.text = imageBody.displayName;
    }else{
        cell.detailTextLabel.text = @"其他";
    }
    return cell;
}
#pragma mark - tableview代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RRChatViewController *chatVC = [UIStoryboard storyboardWithName:@"ChatViewController" bundle:nil].instantiateInitialViewController;
    EMConversation *conversation = self.dataSource[indexPath.row];
    chatVC.username = conversation.chatter;
    EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
    chatVC.buddy = buddy;
    [self.navigationController pushViewController:chatVC animated:YES];
}
#pragma mark - 监听手机的网络状态改变的回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
//    eEMConnectionConnected,   //连接成功
//    eEMConnectionDisconnected,//未连接
    if (connectionState == eEMConnectionConnected) {
        
    }else{
        [RRHUD showError:@"网络断开..."];
    }
}
#pragma mark - 将要发起自动连接的回调
- (void)willAutoReconnect{
    [RRHUD showStatus:@"正在自动连接"];
}
#pragma mark - 自动重连结束后的回调
- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    if (!error) {
        [RRHUD showSuccess:@"网络连接成功!"];
        [[SVTools shareSVTools] svdismiss];
    }else{
        [RRHUD showError:@"自动重连失败..."];
    }
}


#pragma mark - 监听好友请求
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    // 设置好友界面的badgeValue
    UINavigationController *childVC = self.navigationController.tabBarController.childViewControllers[1];
    childVC.tabBarItem.badgeValue = @"22";
    NSDictionary *dict = @{@"key":username,@"value":message};
    [[RRNoticeArr sharenotice].notice addObject:dict];
    
}
#pragma mark - 添加好友的请求被接受!
- (void)didAcceptedByBuddy:(NSString *)username{
    // 设置好友界面的badgeValue
    UINavigationController *childVC = self.navigationController.tabBarController.childViewControllers[1];
    childVC.tabBarItem.badgeValue = @"22";
    NSDictionary *dict = @{@"key":username,@"value":@"他已经同意了你的好友请求!"};
    [[RRNoticeArr sharenotice].notice addObject:dict];
}
#pragma mark - 添加好友的请求被拒绝!
- (void)didRejectedByBuddy:(NSString *)username{
    // 设置好友界面的badgeValue
    UINavigationController *childVC = self.navigationController.tabBarController.childViewControllers[1];
    childVC.tabBarItem.badgeValue = @"22";
    NSDictionary *dict = @{@"key":username,@"value":@"他拒绝了你的好友请求!"};
    [[RRNoticeArr sharenotice].notice addObject:dict];
}

#pragma mark - 监听好友列表发生变化
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{
    
}
#pragma mark - 设置tabbar上的未读消息数
- (void)ShowTabBarItemBadge{
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.dataSource) {
        totalUnreadCount = totalUnreadCount + [conversation unreadMessagesCount];
    }
    if (totalUnreadCount == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    }else{
      self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",totalUnreadCount];
    }
    
}
#pragma mark - 监听未读消息数量的改变
- (void)didUnreadMessagesCountChanged{
    [self loadAllConversations];
    [self.tableView reloadData];
    [self ShowTabBarItemBadge];
}
#pragma mark - 移除代理
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
@end
