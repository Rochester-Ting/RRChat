//
//  RRNoticeCell.m
//  RRChat
//
//  Created by 丁瑞瑞 on 5/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "RRNoticeCell.h"


@interface RRNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
@implementation RRNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    _username.text = [user objectForKey:@"username"];
//    _message.text = [user objectForKey:@"message"];
}
- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    _username.text = dict[@"key"];
    _message.text = dict[@"value"];
}
- (IBAction)agree:(UIButton *)sender {
    if (_agree) {
        _agree(_num);
    }
}
- (IBAction)reject:(UIButton *)sender {
    if (_reject) {
        _reject(_num);
    }
}
- (IBAction)konw:(id)sender {
    if (_know) {
        _know(_num);
    }
}

@end
