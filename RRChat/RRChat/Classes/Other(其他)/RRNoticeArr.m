//
//  RRNoticeArr.m
//  RRChat
//
//  Created by 丁瑞瑞 on 5/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRNoticeArr.h"

@interface RRNoticeArr()

@end
@implementation RRNoticeArr
- (NSMutableArray *)notice{
    if (!_notice) {
        _notice = [NSMutableArray array];
    }
    return _notice;
}
SingleM(notice)
@end
