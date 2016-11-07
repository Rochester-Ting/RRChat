//
//  RRHUD.m
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRHUD.h"
#import <SVProgressHUD.h>
#import "SVTools.h"
@implementation RRHUD
+(void)showSuccess:(NSString *)str{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showSuccessWithStatus:str];
    [[SVTools shareSVTools] svdismiss];
}
+ (void)showError:(NSString *)str{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showErrorWithStatus:str];
    [[SVTools shareSVTools] svdismiss];
}

+ (void)showStatus:(NSString *)str{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:str];
}
@end
