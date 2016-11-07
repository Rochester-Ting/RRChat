//
//  SVTools.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "SVTools.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation SVTools
SingleM(SVTools)
- (void)svdismiss{
    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:0.8];
}
- (void)dismiss:(id)sender{
    [SVProgressHUD dismiss];
}
@end
