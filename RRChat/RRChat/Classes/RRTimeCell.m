//
//  RRTimeCell.m
//  RRChat
//
//  Created by 丁瑞瑞 on 7/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRTimeCell.h"

@interface RRTimeCell ()
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RRTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTimeStr:(NSString *)timeStr{
    _timeStr = timeStr;
    self.time.text = timeStr;
}
@end
