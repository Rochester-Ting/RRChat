//
//  RRNoticeVC.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRNoticeVC.h"
#import "RRNoticeCell.h"
#import "EaseMob.h"
#import "RRHUD.h"
#import "RRNoticeArr.h"
@interface RRNoticeVC ()

@end

@implementation RRNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"好友通知";
    self.tabBarItem.badgeValue = @"0";
    [self.tableView registerNib:[UINib nibWithNibName:@"RRNoticeCell" bundle:nil] forCellReuseIdentifier:@"RRNoticeCell"];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [RRNoticeArr sharenotice].notice.count;
    NSLog(@"--------%zd---------",[RRNoticeArr sharenotice].notice.count);
    return [RRNoticeArr sharenotice].notice.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRNoticeCell"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:@"username"];
    cell.dict = [RRNoticeArr sharenotice].notice[indexPath.row];
    cell.num = indexPath.row;
    cell.agree = ^(NSInteger str){
        EMError *error = nil;
        
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送同意成功");
            [[RRNoticeArr sharenotice].notice removeObjectAtIndex:indexPath.row];
            [RRHUD showSuccess:@"同意!"];
        }
    };
    cell.reject = ^(NSInteger str){
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"111111" error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送拒绝成功");
            [[RRNoticeArr sharenotice].notice removeObjectAtIndex:indexPath.row];
            [RRHUD showSuccess:@"拒绝!"];
        }
    };
    cell.know = ^(NSInteger str){
         [RRHUD showSuccess:@"知道了!"];
        [[RRNoticeArr sharenotice].notice removeObjectAtIndex:indexPath.row];
    };
    return cell;
}

@end
