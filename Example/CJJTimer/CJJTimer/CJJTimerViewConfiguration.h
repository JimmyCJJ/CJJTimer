//
//  CJJTimerViewConfiguration.h
//  CJJTimer
//
//  Created by JimmyCJJ on 2020/8/18.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CJJTimerViewMode){
    CJJTimerViewMode_HMS = 0,//时分秒(默认)
    CJJTimerViewMode_HM,//时分
    CJJTimerViewMode_MS,//分秒
    CJJTimerViewMode_DHMS//天时分秒
};

@class CJJTimerViewConfiguration;
@protocol CJJTimerViewConfigurationDatasource <NSObject>

- (CGFloat)timerViewWidthInConfiguration:(CJJTimerViewConfiguration *)configuration;

@end

@interface CJJTimerViewConfiguration : NSObject

/// 初始化方法（默认CJJTimerViewMode_HMS）
+ (instancetype)configureTimerView;

/// 初始化方法（自定义mode）
+ (instancetype)configureTimerViewWithMode:(CJJTimerViewMode)mode;

/// 改变模式
/// @param mode 传入模式
- (void)changeMode:(CJJTimerViewMode)mode;

#pragma mark - Function Config
/// 倒数截止的时间（传时间戳，必传）
@property (nonatomic, copy) NSString *timerLastTime;
/// 是否自动开启定时器，默认YES
@property (nonatomic, assign, getter=isTimerAutoStart) BOOL timerAutoStart;
/// 倒计时结束后是否隐藏，默认YES，如果设为NO，则显示初始值00:00:00
@property (nonatomic, assign, getter=isTimerHiddenWhenFinished) BOOL timerHiddenWhenFinished;
/// 是否自动切换模式（例如原来设为CJJTimerViewMode_DHMS，但不足一天自动切换为CJJTimerViewMode_HMS，以此类推），默认NO
@property (nonatomic, assign, getter=isTimerAutoChangeMode) BOOL timerAutoChangeMode;

#pragma mark - UI Config
/// 时间块的宽度，默认24
@property (nonatomic, assign) CGFloat timerViewWidth;
/// 时间块的高度，默认24
@property (nonatomic, assign) CGFloat timerViewHeight;
/// 冒号的宽度，设置天时分秒，默认为10，若对应位置无值则自动计算为0
@property (nonatomic, assign) CGFloat timerColonWidth;
/// 冒号的宽度，设置天，默认16
@property (nonatomic, assign) CGFloat timerDayColonWidth;
/// 冒号的宽度，设置时，默认10
@property (nonatomic, assign) CGFloat timerHourColonWidth;
/// 冒号的宽度，设置分，默认10
@property (nonatomic, assign) CGFloat timerMinColonWidth;
/// 冒号的宽度，设置秒，默认0
@property (nonatomic, assign) CGFloat timerSecColonWidth;
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
/// 天 默认天，可改成其他，例如-，等
@property (nonatomic, copy) NSString *timerColonDayLabelText;
/// 时 默认冒号，可改成其他，例如-，时等
@property (nonatomic, copy) NSString *timerColonHourLabelText;
/// 分 默认冒号，可改成其他，例如-，  分等
@property (nonatomic, strong) NSString *timerColonMinLabelText;
/// 秒 默认空字符串，可改成其他，例如-，秒等
@property (nonatomic, strong) NSString *timerColonSecLabelText;

/// 自动计算timer的宽度
@property (nonatomic, assign, readonly) CGFloat timerWidth;
/// 自动计算timer的高度
@property (nonatomic, assign, readonly) CGFloat timerHeight;
/// 当前模式
@property (nonatomic, assign, readonly) CJJTimerViewMode mode;
@property (nonatomic, weak) id<CJJTimerViewConfigurationDatasource> datasource;


@end

NS_ASSUME_NONNULL_END
