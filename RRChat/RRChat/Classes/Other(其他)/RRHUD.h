//
//  RRHUD.h
//  RRChat
//
//  Created by 丁瑞瑞 on 4/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRHUD : NSObject
+(void)showSuccess:(NSString *)str;
+(void)showError:(NSString *)str;
+(void)showStatus:(NSString *)str;
@end
