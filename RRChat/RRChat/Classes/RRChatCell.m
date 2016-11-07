//
//  RRChatCell.m
//  RRChat
//
//  Created by 丁瑞瑞 on 6/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRChatCell.h"
#import "EMMessage.h"
#import "EaseMob.h"
#import "RRVoiceTools.h"
#import "MJPhotoBrowser.h"
@interface RRChatCell ()
/** <#注释#>*/
@property (nonatomic,strong) UIImageView *imageV;
@end
@implementation RRChatCell
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // 创建一个点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.msgLabel addGestureRecognizer:tap];
//    self.isPlay = NO;
}
#pragma mark - 手势点击

- (void)tap:(UITapGestureRecognizer *)tap{
    BOOL isReceiver = [self.reuseIdentifier isEqualToString:receiverCellId];
    id messageBody = self.message.messageBodies[0];
    if ([messageBody isKindOfClass:[EMVoiceMessageBody class]]) {
          [[RRVoiceTools shareVoiceTools] play:messageBody withLabel:self.msgLabel isReceiver:isReceiver];
    }else{
        return;
    }
}
#pragma mark - message的set方法
- (void)setMessage:(EMMessage *)message{
    _message = message;
    [self.imageV removeFromSuperview];
    // 获取消息体
    id messageBody = message.messageBodies[0];
    if ([messageBody isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = messageBody;
        self.msgLabel.text = textBody.text;
    }else if([messageBody isKindOfClass:[EMVoiceMessageBody class]]){
        
//        self.msgLabel.text = @"语音消息";
        [self setVoice:messageBody];
    }else if([messageBody isKindOfClass:[EMImageMessageBody class]]){
        [self showImage:messageBody];
    }else{
        self.msgLabel.text = @"其他消息";
    }
}
- (void)setVoice:(EMVoiceMessageBody *)voiceBody{
    // 创建一个可变的富文本
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    // 判断是收信人还是发信人
    BOOL isReceiver = [self.reuseIdentifier isEqualToString:receiverCellId];
    if (isReceiver) {
        // 图片
        NSTextAttachment *attaChment = [[NSTextAttachment alloc] init];
        attaChment.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
        attaChment.bounds = CGRectMake(0, -6, 25, 25);
        NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attaChment];
        [attString appendAttributedString:imgString];
        // 文字
        NSString *timer = [NSString stringWithFormat:@"%ld'",voiceBody.duration];
        NSAttributedString *labelString = [[NSAttributedString alloc] initWithString:timer];
        [attString appendAttributedString:labelString];
        
    }else{
        // 文字
        NSString *timer = [NSString stringWithFormat:@"%ld'",voiceBody.duration];
        NSAttributedString *labelString = [[NSAttributedString alloc] initWithString:timer];
        [attString appendAttributedString:labelString];
        // 图片
        NSTextAttachment *attaChment = [[NSTextAttachment alloc] init];
        attaChment.image = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
        attaChment.bounds = CGRectMake(0, -6, 25, 25);
        NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attaChment];
        [attString appendAttributedString:imgString];
        
    }
    self.msgLabel.attributedText = attString;
}
- (void)showImage:(EMImageMessageBody *)imageBody{
    
    
     NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attaChment = [[NSTextAttachment alloc] init];
    // 查看图片是否在本地,不在就从服务器下载
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageBody.thumbnailLocalPath]) {
        NSURL *url = [NSURL URLWithString:imageBody.thumbnailRemotePath];
        [self.imageV sd_setImageWithURL:url];

    }else{
        self.imageV.image = [UIImage imageWithContentsOfFile:imageBody.thumbnailLocalPath];
    }
    
    attaChment.bounds = CGRectMake(0, 0, imageBody.thumbnailSize.width, imageBody.thumbnailSize.height);
    NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attaChment];
    [attString appendAttributedString:imgString];
    self.msgLabel.attributedText = attString;
    self.imageV.frame = attaChment.bounds;
    [self.msgLabel addSubview:_imageV];
    self.imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.imageV addGestureRecognizer:tap];
}
- (void)tapImage:(UITapGestureRecognizer *)tap{
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    MJPhoto *photo = ({
        MJPhoto *photo = [[MJPhoto alloc] init];
        EMImageMessageBody *imageBody = (EMImageMessageBody *)self.message.messageBodies[0];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:imageBody.localPath]) {
            photo.url = [NSURL URLWithString:imageBody.remotePath];
        }else{
            photo.image = [UIImage imageWithContentsOfFile:imageBody.localPath];
        }
        photo.srcImageView = self.imageV;
        photo;
    });
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}
@end

