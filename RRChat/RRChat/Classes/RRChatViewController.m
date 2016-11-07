//
//  RRChatViewController.m
//  RRChat
//
//  Created by 丁瑞瑞 on 5/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRChatViewController.h"
#import "RRChatCell.h"
#import "EaseMob.h"
#import "RRHUD.h"
#import "EMCDDeviceManager.h"
#import "RRVoiceTools.h"
#import "RRTimeTool.h"
#import "RRTimeCell.h"
//#import "EMMessage.h"
@interface RRChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,EMChatManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottom;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

/** <#注释#>*/
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
// 语音 提示的view
@property (weak, nonatomic) IBOutlet UIView *recordTitle;

@property (weak, nonatomic) IBOutlet UITextView *textView;

/** 上一个时间*/
@property (nonatomic,strong) NSString *lastTimeStr;

@end

@implementation RRChatViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollToBottom];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.username;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 拖动的时候隐藏键盘
    self.tableView.keyboardDismissMode =  UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // 从本地数据库获取聊天记录
    [self loadMessageFromeDB];
    // 设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];;
    
#pragma mark - 监听键盘的弹出
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
#pragma mark - 监听键盘的消失
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - tableview滚到底部
- (void)scrollToBottom{
    if (self.dataSource.count == 0) {
        return;
    }
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)keyboardWillShow:(NSNotification *)center{
    CGRect kFrame = [center.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kHeight =  kFrame.size.height;
    self.inputViewBottom.constant = kHeight;
    [self scrollToBottom];
}
- (void)keyboardWillHide:(NSNotificationCenter *)center{
    self.inputViewBottom.constant = 0;
    
    
}
#pragma mark - tableview数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // receiverCell
    // sendCell
    // 取出消息
    id message = self.dataSource[indexPath.row];
    
    if ([message isKindOfClass:[NSString class]]) {
        RRTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time"];
        cell.timeStr = message;
        return  cell;
    }
    
    RRChatCell *cell;
    EMMessage *msg = (EMMessage *)message;
    if (![msg.from isEqualToString:self.buddy.username]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"sendCell"];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"receiverCell"];
        
    }
    cell.message = message;
    cell.isPlay = NO;
    return cell;
    
    
}
#pragma mark - tableView的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[RRVoiceTools shareVoiceTools] stop];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    // 获取文字的高度
    CGFloat labelHeight = ceilf([textView sizeThatFits:textView.frame.size].height);;
    
    if (labelHeight > 68) {
        labelHeight = 68;
    }else if(labelHeight < 33){
        labelHeight = 33;
    }
    CGFloat inputViewHeight = 6 + labelHeight + 7;
    self.inputViewHeight.constant = inputViewHeight;
    // 判断最后一个是不是换行,如果是那么发送消息
    if ([textView.text hasSuffix:@"\n"]) {
        // 发送消息
        [self sendMessage:textView.text];
        textView.text = nil;
        self.inputViewHeight.constant = 46;
//
        NSLog(@"发送!");
    }
#pragma mark - 修复光标不居中的bug
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - 发送消息
- (void)sendMessage:(NSString *)text{
    // 构造文字消息
    text = [text substringToIndex:text.length - 1];
    EMChatText *txtChat = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    message.messageType = eMessageTypeChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        if (!error) {
            [RRHUD showStatus:@"正在发送!"];
        }
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        [RRHUD showSuccess:@"发送成功!"];
    } onQueue:nil];
    
    if ([message.to isEqualToString:self.buddy.username]) {
        [self.dataSource addObject:message];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}
#pragma mark - 从本地数据库获取聊天记录
- (void)loadMessageFromeDB{
    // 获取单聊的聊天记录
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    NSArray *conversations = [conversation loadAllMessages];
    // 遍历消息获取,每条消息的时间
    for (EMMessage *msg in conversations) {
        NSString *time = [RRTimeTool timeStr:msg.timestamp];
        if (![time isEqualToString:self.lastTimeStr]) {
            [self.dataSource addObject:time];
        }
        self.lastTimeStr = time;
        [self.dataSource addObject:msg];
        
        // 更改消息的状态
        if (msg.isRead == NO) {
            [conversation markMessageWithId:msg.messageId asRead:YES];
        }
    }
//    [self.dataSource addObjectsFromArray:conversations];
}
#pragma mark - 监听收到消息
- (void)didReceiveMessage:(EMMessage *)message{
    
    if ([message.from isEqualToString:self.buddy.username]) {
        if (message.messageType != eMessageTypeChat) {
            return;
        }
        [self.dataSource addObject:message];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}
#pragma mark - 录音按钮
- (IBAction)recordBtnClick:(id)sender {
    // 退出键盘
    if (self.recordBtn.hidden) {
        [self.view endEditing:YES];
        self.inputViewHeight.constant = 46;
    }else{
        [self.textView becomeFirstResponder];
        [self textViewDidChange:self.textView];
    }
    
    
    // 显示录音按钮
    self.recordBtn.hidden = !self.recordBtn.hidden;
}
#pragma mark - 开始录音
- (IBAction)startRecord:(UIButton *)sender {
    // 设置录音文件的名字
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            [RRHUD showSuccess:@"录音开启成功!"];
            
            
        }
    }];
    
}
#pragma mark - 设置recordTitle出现
- (void)recordTitleClick{
    self.recordTitle.hidden = !self.recordTitle.hidden;
}
#pragma mark - 结束录音
- (IBAction)endRecord:(id)sender {
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            // 录音结束成功!
            [self sendVoicePath:recordPath withDuration:aDuration];
            [RRHUD showSuccess:@"录音结束!"];
            
        }
    }];
}
#pragma mark - 结束录音
- (IBAction)cancelRecord:(id)sender {
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [RRHUD showError:@"录音已经取消!"];
    
}
#pragma mark - 发送录音
- (void)sendVoicePath:(NSString *)filePath withDuration:(NSInteger)aDuration{
    EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:filePath displayName:@"语音"];
    voice.duration = aDuration;
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [RRHUD showSuccess:@"语音发送成功!"];
            [self.dataSource addObject:message];
            [self.tableView reloadData];
            [self scrollToBottom];
        }
    } onQueue:nil];
    
}
#pragma mark - 选择图片
- (IBAction)selectImage:(id)sender {
    UIImagePickerController *imagePickVC = [[UIImagePickerController alloc] init];
    imagePickVC.delegate = self;
//    imagePickVC.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickVC animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self sendPicture:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendPicture:(UIImage *)image{
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:image displayName:@"[图片]"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
    //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            NSLog(@"图片发送成功!");
            [self.dataSource addObject:message];
            [self.tableView reloadData];
            [self scrollToBottom];
        }else{
            NSLog(@"error ==== %@",error);
        }
    } onQueue:nil];
}
#pragma mark - 移除代理
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
