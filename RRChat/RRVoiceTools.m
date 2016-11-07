//
//  RRVoiceTools.m
//  RRChat
//
//  Created by 丁瑞瑞 on 6/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRVoiceTools.h"
#import "EMCDDeviceManager.h"
static UIImageView *currentImageView = nil;
@interface RRVoiceTools()
/** <#注释#>*/
@end
@implementation RRVoiceTools
SingleM(VoiceTools);
- (void)play:(EMVoiceMessageBody *)voiceBody withLabel:(UILabel *)msgLabel isReceiver:(BOOL)isReceiver{
    [currentImageView removeFromSuperview];
    // 查看本地是否有文件,如果有,播放本地文件,如果没有从服务器获取
    NSString *voicePath = voiceBody.localPath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        voicePath = voiceBody.remotePath;
    }
    // 播放
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
        
        if (!error) {
            NSLog(@"voiceBody.remotePath=%@",voiceBody.remotePath);
            NSLog(@"播放完成!");
            [currentImageView stopAnimating];
        }else{
            NSLog(@"error===%@",error);
        }
    }];
//    2.设置图片
    UIImageView *animationImage = [[UIImageView alloc] init];
    CGFloat imH = msgLabel.bounds.size.height;
    CGFloat imW = imH;
    CGFloat imX = 0;
    CGFloat imY = 0;
    if (isReceiver) {
        animationImage.animationImages = @[
                                           [UIImage imageNamed:@"chat_receiver_audio_playing000"],
                                           [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                                           [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                                           [UIImage imageNamed:@"chat_receiver_audio_playing003"]
                                           ];
    }else{
        animationImage.animationImages = @[
                                           [UIImage imageNamed:@"chat_sender_audio_playing_000"],
                                           [UIImage imageNamed:@"chat_sender_audio_playing_001"],
                                           [UIImage imageNamed:@"chat_sender_audio_playing_002"],
                                           [UIImage imageNamed:@"chat_sender_audio_playing_003"]
                                           ];
        imX = msgLabel.bounds.size.width - imW;
    }
    currentImageView = animationImage;
    animationImage.frame = CGRectMake(imX, imY, imW, imH);
    [msgLabel addSubview:animationImage];
    animationImage.animationDuration = 1;
    [animationImage startAnimating];
    
}
- (void)stop{
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [currentImageView removeFromSuperview];
    
}
@end
