//
//  CJJSMSTimer.h
//  CJJTimer
//
//  Created by CJJ on 2020/2/20.
//  Copyright © 2020 CJJTimer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CJJSMSTimerBlock)(void);

@interface CJJSMSTimer : NSObject

/// 开启倒计时
/// @param btn 传入按钮对象
/// @param timeOut 传入倒数总时间
/// @param finishedTitle 倒数结束后的标题
/// @param finishedTitleColor 倒数结束后的标题颜色
/// @param ingTitle 倒数进行时的标题
/// @param ingTitleColor 倒数进行时的标题颜色
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                          finishedTitle:(NSString *)finishedTitle
                      finishedTitleColor:(UIColor *)finishedTitleColor
                               ingTitle:(NSString *)ingTitle
                           ingTitleColor:(UIColor *)ingTitleColor;

/// 开启倒计时
/// @param btn 传入按钮对象
/// @param timeOut 传入倒数总时间
/// @param finishedTitle 倒数结束后的标题
/// @param finishedTitleColor 倒数结束后的标题颜色
/// @param ingTitle 倒数进行时的标题
/// @param ingTitleColor 倒数进行时的标题颜色
/// @param finishedBlock 倒数结束后的设置
/// @param ingBlock 倒数进行时的设置
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                          finishedTitle:(NSString *)finishedTitle
                      finishedTitleColor:(UIColor *)finishedTitleColor
                               ingTitle:(NSString *)ingTitle
                           ingTitleColor:(UIColor *)ingTitleColor
                   titleFinishSettingBlock:(CJJSMSTimerBlock __nullable)finishedBlock
                      titleIngSettingBlock:(CJJSMSTimerBlock __nullable)ingBlock;


/// 销毁定时器（如果想手动控制销毁的时机请调用此方法，否则自动销毁）
- (void)destroyTimer;
@end

NS_ASSUME_NONNULL_END
