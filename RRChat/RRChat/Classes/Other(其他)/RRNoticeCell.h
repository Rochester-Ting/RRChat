//
//  RRNoticeCell.h
//  RRChat
//
//  Created by 丁瑞瑞 on 5/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRNoticeCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic,copy) void(^agree)(NSInteger str);

@property (nonatomic,copy) void(^reject)(NSInteger str);

@property (nonatomic,copy) void(^know)(NSInteger str);
/** <#注释#>*/
@property (nonatomic,strong) NSDictionary *dict;

/** <#注释#>*/
@property (nonatomic,assign) NSInteger num;
@end
