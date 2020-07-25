//
//  CJJTimerView.h
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

typedef void (^CJJTimerViewLayout)(CGFloat timerWidth, CGFloat timerHeight);

@class CJJTimerView,CJJTimerViewConfiguration;
@protocol CJJTimerViewDelegate <NSObject>

/// 倒计时结束回调
- (void)timerFinished:(CJJTimerView *)timerView;

@end

@interface CJJTimerView : UIView

/// 初始化方法（唯一）
/// @param configuration 配置
+ (instancetype)timerViewWithConfiguration:(CJJTimerViewConfiguration *)configuration;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@property (nonatomic, strong) CJJTimerViewConfiguration *configuration;
@property (nonatomic, weak) id<CJJTimerViewDelegate> delegate;


/// 自动布局
/// @param layout 此block会返回自动计算后的timerView的width和height，可用于布局
- (void)configureLayout:(CJJTimerViewLayout)layout;

/// beginTimer与endTimer成对使用
/// 开启定时器
- (dispatch_source_t)startTimer;
/// 销毁定时器（如果想手动控制销毁的时机请调用此方法，否则自动销毁）
- (void)stopTimer;

/// suspendTimer和resumeTimer成对使用
/// 暂停定时器
- (void)suspendTimer;
/// 恢复定时器
- (void)resumeTimer;

/// 重置定时器（传时间戳）
- (void)resetTimerWithlastTime:(NSString *)lastTime;

@end

@interface CJJTimerViewConfiguration : NSObject

+ (instancetype)configureTimerView;

#pragma mark - Function Config
/// 倒数截止的时间（传时间戳，必传）
@property (nonatomic, copy) NSString *timerLastTime;
/// 是否自动开启定时器，默认YES
@property (nonatomic, assign, getter=isTimerAutoStart) BOOL timerAutoStart;
/// 倒计时结束后是否隐藏，默认YES，如果设为NO，则显示初始值00:00:00
@property (nonatomic, assign, getter=isTimerHiddenWhenFinished) BOOL timerHiddenWhenFinished;

#pragma mark - UI Config
/// 时间块的宽度，默认22
@property (nonatomic, assign) CGFloat timerViewWidth;
/// 时间块的高度，默认22
@property (nonatomic, assign) CGFloat timerViewHeight;
/// 块与冒号之间的间隔，默认4
@property (nonatomic, assign) CGFloat timerViewInset;
/// 冒号的宽度，默认4
@property (nonatomic, assign) CGFloat timerColonWidth;
/// 内边距，默认 UIEdgeInsetsZero
@property(nonatomic) UIEdgeInsets timerInsets;
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

NS_ASSUME_NONNULL_END
