//
//  RRVoiceTools.h
//  RRChat
//
//  Created by 丁瑞瑞 on 6/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"
#import "Single.h"
@interface RRVoiceTools : NSObject
SingleH(VoiceTools);
// 播放
- (void)play:(EMVoiceMessageBody *)voiceBody withLabel:(UILabel *)msgLabel isReceiver:(BOOL)isReceiver;
// 停止
- (void)stop;


@end
