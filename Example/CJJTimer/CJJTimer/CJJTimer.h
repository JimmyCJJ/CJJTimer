//
//  CJJTimer.h
//  CJJTimer
//
//  Created by CJJ on 2020/7/21.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CJJTimerLayout)(CGFloat width, CGFloat height);

@interface CJJTimerConfiguration : NSObject

+ (instancetype)configureTimer;

#pragma mark - Function Config
/// 倒数截止的时间（传时间戳）
@property (nonatomic, assign) NSString *timerLastTime;

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

+ (instancetype)timerWithConfigure:(CJJTimerConfiguration *)configuration;

/// 自动布局
/// @param layout 此block会返回自动计算后的timer的width和height，可用于布局
- (void)configureLayout:(CJJTimerLayout)layout;

/// 开启倒计时
- (void)beginTimer;
/// 停止倒计时，**必须手动调用才能销毁**
- (void)endTimer;

@end

NS_ASSUME_NONNULL_END
