//
//  CJJTimerTool.h
//  CJJTimer
//
//  Created by 曹鉴津 on 2021/6/3.
//  Copyright © 2021 CAOJIANJIN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CJJTimerToolFormat) {
    CJJTimerToolFormat_Day,
    CJJTimerToolFormat_Hour,
    CJJTimerToolFormat_Min,
    CJJTimerToolFormat_sec
};

@interface CJJTimerTool : NSObject
+ (NSInteger)getNumberOfDaysOneYear:(NSDate *)date;
+ (NSDateComponents *)startTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp format:(CJJTimerToolFormat)format;
+ (NSString *)getNowTimeTimeStampSec;
+ (NSString *)getNowTimeTimestampMinSec;
+ (CGFloat)getLabelHeightWithString:(NSString *)string Width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)getLabelWidthWithString:(NSString *)string Height:(CGFloat)height font:(UIFont *)font;
+ (BOOL)NullStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
