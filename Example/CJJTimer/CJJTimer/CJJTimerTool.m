//
//  CJJTimerTool.m
//  CJJTimer
//
//  Created by 曹鉴津 on 2021/6/3.
//  Copyright © 2021 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerTool.h"

@implementation CJJTimerTool

#pragma mark - 获取某个日期所在年份的天数

+ (NSInteger)getNumberOfDaysOneYear:(NSDate *)date {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitYear
                                  forDate: date];
    return range.length;
}

+ (NSDateComponents *)startTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp format:(CJJTimerToolFormat)format {
    //东八区-北京时间
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    // 两个时间戳转换日期类
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:[startTimeStamp doubleValue] + delta];
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:[endTimeStamp doubleValue] + delta];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit;
    switch (format) {
        case CJJTimerToolFormat_Day:
            unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            break;
        case CJJTimerToolFormat_Hour:
            unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            break;
        case CJJTimerToolFormat_Min:
            unit = NSCalendarUnitMinute | NSCalendarUnitSecond;
            break;
        case CJJTimerToolFormat_sec:
            unit = NSCalendarUnitSecond;
            break;
        default:
            unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            break;
    }
    
    NSDateComponents *cmps = [calendar components:unit fromDate:startDate toDate:endDate options:0];
//    NSLog(@"剩余%ld天,%ld小时%ld分%ld秒", cmps.day ,cmps.hour, cmps.minute, cmps.second);
    return cmps;
}

////返回秒为单位的时间戳
+ (NSString *)getNowTimeTimeStampSec {

    NSDate *datenow = [NSDate date];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;

}

//返回毫秒为单位的时间戳
+ (NSString *)getNowTimeTimestampMinSec {
    
    NSDate *datenow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    
    return timeSp;
}



+ (CGFloat)getLabelHeightWithString:(NSString *)string Width:(CGFloat)width font:(UIFont *)font {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                   
                                     options:NSStringDrawingUsesLineFragmentOrigin
                   
                                  attributes:@{NSFontAttributeName:font} context:nil];
    
    
    return rect.size.height;
    
}

+ (CGFloat)getLabelWidthWithString:(NSString *)string Height:(CGFloat)height font:(UIFont *)font {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                   
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                   
                                     context:nil];
    return rect.size.width;
}

#pragma mark - private

+ (BOOL)NullStr:(NSString *)str {
    if (!str) {
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (!str.length) {
        return YES;
    }

    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}


@end
