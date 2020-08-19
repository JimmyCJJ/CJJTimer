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

#pragma mark - UI Config
/// 时间块的宽度，默认22
- (CJJTimerViewConfiguration *(^)(CGFloat))viewWidth;
/// 时间块的高度，默认22
- (CJJTimerViewConfiguration *(^)(CGFloat))viewHeight;
/// 块与冒号之间的间隔，默认4
- (CJJTimerViewConfiguration *(^)(CGFloat))horizontalInset;
/// 冒号的宽度，默认4
- (CJJTimerViewConfiguration *(^)(CGFloat))colonWidth;
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
/// 时 默认冒号，可改成其他，例如-，时等
- (CJJTimerViewConfiguration *(^)(NSString *))colonHourLabelText;
/// 分 默认冒号，可改成其他，例如-，  分等
- (CJJTimerViewConfiguration *(^)(NSString *))colonMinLabelText;
/// 秒 默认空字符串，可改成其他，例如-，秒等
- (CJJTimerViewConfiguration *(^)(NSString *))colonSecLabelText;


@end

NS_ASSUME_NONNULL_END
