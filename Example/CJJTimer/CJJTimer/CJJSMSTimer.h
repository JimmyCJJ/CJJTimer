//
//  CJJSMSTimer.h
//  CJJTimer
//
//  Created by CJJ on 2020/2/20.
//  Copyright © 2020 CJJTimer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CJJSMSTimerVoidBlock)(void);
typedef void (^CJJSMSTimerSecBlock)(int sec);

@interface CJJSMSTimer : NSObject

/// 开启倒计时 - 完全自定义回调
/// @param btn 传入按钮对象
/// @param timeOut 传入倒数总时间
/// @param ingBlock 倒数进行时的设置
/// @param finishedBlock 倒数结束后的设置
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                    titleIngSettingBlock:(CJJSMSTimerSecBlock __nullable)ingBlock
                  titleFinishSettingBlock:(CJJSMSTimerVoidBlock __nullable)finishedBlock;

/// 开启倒计时 - 默认回调
/// @param btn 传入按钮对象
/// @param timeOut 传入倒数总时间
/// @param ingTitle 倒数进行时的标题
/// @param ingTitleColor 倒数进行时的标题颜色
/// @param finishedTitle 倒数结束后的标题
/// @param finishedTitleColor 倒数结束后的标题颜色
/// @param ingBlock 倒数进行时的设置
/// @param finishedBlock 倒数结束后的设置
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                               ingTitle:(NSString *)ingTitle
                           ingTitleColor:(UIColor *)ingTitleColor
                           finishedTitle:(NSString *)finishedTitle
                       finishedTitleColor:(UIColor *)finishedTitleColor
                      titleIngSettingBlock:(CJJSMSTimerSecBlock __nullable)ingBlock
                    titleFinishSettingBlock:(CJJSMSTimerVoidBlock __nullable)finishedBlock;


/// 销毁定时器（如果想手动控制销毁的时机请调用此方法，否则自动销毁）
- (void)destroyTimer;
@end

NS_ASSUME_NONNULL_END
