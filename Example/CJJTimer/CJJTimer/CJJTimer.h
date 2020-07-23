//
//  CJJTimer.h
//  CJJTimer
//
//  Created by JimmyCJJ on 2020/7/21.
//  github   : https://github.com/JimmyCJJ
//  wechat   : cjj_ohyeah
//  E-mail   : 403327747@qq.com
//  jianshu  : https://www.jianshu.com/u/fd9922e50c1a
//  欢迎同行一起交流
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CJJTimerLayout)(CGFloat timerWidth, CGFloat timerHeight);

@interface CJJTimerConfiguration : NSObject

+ (instancetype)configureTimer;

#pragma mark - Function Config
/// 倒数截止的时间（传时间戳）
@property (nonatomic, copy) NSString *timerLastTime;
/// 是否自动开启定时器，默认YES
@property (nonatomic, assign, getter=isTimerAutoStart) BOOL timerAutoStart;

#pragma mark - UI Config
/// 时间块的宽度，默认22
@property (nonatomic, assign) CGFloat timerViewWidth;
/// 时间块的高度，默认22
@property (nonatomic, assign) CGFloat timerViewHeight;
/// 块与冒号之间的间隔，默认4
@property (nonatomic, assign) CGFloat timerViewInset;
/// 冒号的宽度，默认4
@property (nonatomic, assign) CGFloat timerColonWidth;
/// timerView的背景颜色
@property (nullable, nonatomic, strong) UIColor *timerViewBackgroundColor;
/// timerView的圆角
@property (nonatomic, assign) CGFloat timerViewCornerRadius;
/// timerView的阴影颜色
@property (nullable, nonatomic, strong) UIColor *timerViewShadowColor;
/// timerView的阴影偏移
@property (nonatomic, assign) CGSize timerViewShadowOffset;
/// timerView的不透明度
@property (nonatomic, assign) CGFloat timerViewShadowOpacity;
/// timerView的阴影圆角
@property (nonatomic, assign) CGFloat timerViewShadowRadius;

/// 时间颜色
@property (nullable, nonatomic, strong) UIColor *timerTextLabelColor;
/// 冒号颜色
@property (nullable, nonatomic, strong) UIColor *timerColonLabelColor;
/// 时间字体
@property (nonatomic, strong) UIFont *timerTextLabelFont;
/// 冒号字体
@property (nonatomic, strong) UIFont *timerColonLabelFont;

/// 自动计算timer的宽度
@property (nonatomic, assign, readonly) CGFloat timerWidth;
/// 自动计算timer的高度
@property (nonatomic, assign, readonly) CGFloat timerHeight;
@end

@interface CJJTimer : UIView

@property (nonatomic, strong) CJJTimerConfiguration *configuration;

+ (instancetype)timerWithConfiguration:(CJJTimerConfiguration *)configuration;

/// 自动布局
/// @param layout 此block会返回自动计算后的timer的width和height，可用于布局
- (void)configureLayout:(CJJTimerLayout)layout;

/// beginTimer与endTimer成对使用
/// 开启定时器
- (dispatch_source_t)startTimer;
/// 销毁定时器（如果想手动控制释放的时机请调用此方法，否则自动释放）
- (void)stopTimer;

/// suspendTimer和resumeTimer成对使用
/// 暂停定时器
- (void)suspendTimer;
/// 恢复定时器
- (void)resumeTimer;

/// 重置定时器
- (void)resetTimer;

@end

NS_ASSUME_NONNULL_END
