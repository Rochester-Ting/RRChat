//
//  RRChatCell.h
//  RRChat
//
//  Created by 丁瑞瑞 on 6/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMMessage;
static NSString *receiverCellId = @"receiverCell";
static NSString *sendCellId = @"sendCell";
@interface RRChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
/** <#注释#>*/
@property (nonatomic,strong) EMMessage *message;

/** <#注释#>*/
@property (nonatomic,assign) BOOL isPlay;
@end
