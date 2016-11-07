//
//  RRChatViewController.h
//  RRChat
//
//  Created by 丁瑞瑞 on 5/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMBuddy;
@interface RRChatViewController : UIViewController
/** <#注释#>*/
@property (nonatomic,strong) NSString *username;
/** <#注释#>*/
@property (nonatomic,strong) EMBuddy *buddy;
@end
