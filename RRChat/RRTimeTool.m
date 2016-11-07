//
//  RRTimeTool.m
//  RRChat
//
//  Created by 丁瑞瑞 on 7/11/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//
// 将时间戳转成日期
#import "RRTimeTool.h"

@implementation RRTimeTool
+ (NSString *)timeStr:(long long)times{
    // 获取现在的时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:[NSDate date]];
    NSInteger currentDay = components.day;
    NSInteger currentMonth = components.month;
    // 获取传入的时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times/1000.0];
    components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:date];
    // 获取日和月
    NSInteger msgDay = components.day;
    NSInteger msgMonth = components.month;
    NSString *timeFormat = nil;
    
    if (currentMonth == msgMonth && msgDay == currentDay) {
        timeFormat = @"HH:mm";
    }else if (currentDay == (msgDay + 1) && currentMonth == msgMonth){
        timeFormat = @"昨天 HH:mm";
    }else{
        timeFormat = @"yyyy-mm-dd HH:mm";
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = timeFormat;
    return [format stringFromDate:date];
}
@end
