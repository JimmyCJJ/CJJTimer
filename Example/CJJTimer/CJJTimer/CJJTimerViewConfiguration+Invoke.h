//
//  CJJTimerViewConfiguration+Invoke.h
//  CJJTimer
//
//  Created by JimmyCJJ on 2020/8/18.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJJTimerViewConfiguration (Invoke)

#pragma mark - Function Config
/// 倒数截止的时间（传时间戳，必传）
- (CJJTimerViewConfiguration *(^)(NSString *))lastTime;
/// 是否自动开启定时器，默认YES
- (CJJTimerViewConfiguration *(^)(BOOL))autoStart;
/// 倒计时结束后是否隐藏，默认YES，如果设为NO，则显示初始值00:00:00
- (CJJTimerViewConfiguration *(^)(BOOL))hiddenWhenFinished;
/// 是否自动切换模式（例如原来设为CJJTimerViewMode_DHMS，但不足一天自动切换为CJJTimerViewMode_HMS，以此类推），默认NO
- (CJJTimerViewConfiguration *(^)(BOOL))autoChangeMode;

#pragma mark - UI Config
/// 时间块的宽度，默认24
- (CJJTimerViewConfiguration *(^)(CGFloat))viewWidth;
/// 时间块的高度，默认24
- (CJJTimerViewConfiguration *(^)(CGFloat))viewHeight;
/// 冒号的宽度，设置天时分秒，默认为10，若对应位置无值则自动计算为0
- (CJJTimerViewConfiguration *(^)(CGFloat))colonWidth;
/// 冒号的宽度，设置天，默认16
- (CJJTimerViewConfiguration *(^)(CGFloat))dayColonWidth;
/// 冒号的宽度，设置时，默认10
- (CJJTimerViewConfiguration *(^)(CGFloat))hourColonWidth;
/// 冒号的宽度，设置分，默认10
- (CJJTimerViewConfiguration *(^)(CGFloat))minColonWidth;
/// 冒号的宽度，设置秒，默认0
- (CJJTimerViewConfiguration *(^)(CGFloat))secColonWidth;
/// 内边距，默认 UIEdgeInsetsZero
- (CJJTimerViewConfiguration *(^)(UIEdgeInsets))insets;
/// timerView的背景颜色
- (CJJTimerViewConfiguration *(^)(UIColor *))backgroundColor;
/// timerView的圆角
- (CJJTimerViewConfiguration *(^)(CGFloat))cornerRadius;
/// timerView的阴影颜色
- (CJJTimerViewConfiguration *(^)(UIColor *))shadowColor;
/// timerView的阴影偏移
- (CJJTimerViewConfiguration *(^)(CGSize))shadowOffset;
/// timerView的不透明度
- (CJJTimerViewConfiguration *(^)(CGFloat))shadowOpacity;
/// timerView的阴影圆角
- (CJJTimerViewConfiguration *(^)(CGFloat))shadowRadius;
/// 时间颜色
- (CJJTimerViewConfiguration *(^)(UIColor *))textLabelColor;
/// 冒号颜色
- (CJJTimerViewConfiguration *(^)(UIColor *))colonLabelColor;
/// 时间字体
- (CJJTimerViewConfiguration *(^)(UIFont *))textLabelFont;
/// 冒号字体
- (CJJTimerViewConfiguration *(^)(UIFont *))colonLabelFont;
/// 天 默认天，可改成其他，例如-，等
@property (nonatomic, copy) NSString *timerColonDayLabelText;
/// 天 默认天，可改成其他，例如-等
- (CJJTimerViewConfiguration *(^)(NSString *))colonDayLabelText;
/// 时 默认冒号，可改成其他，例如-，时等
- (CJJTimerViewConfiguration *(^)(NSString *))colonHourLabelText;
/// 分 默认冒号，可改成其他，例如-，  分等
- (CJJTimerViewConfiguration *(^)(NSString *))colonMinLabelText;
/// 秒 默认空字符串，可改成其他，例如-，秒等
- (CJJTimerViewConfiguration *(^)(NSString *))colonSecLabelText;


@end

NS_ASSUME_NONNULL_END
