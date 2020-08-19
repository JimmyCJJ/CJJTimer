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
};

@interface CJJTimerViewConfiguration : NSObject

/// 初始化方法（默认CJJTimerViewMode_HMS）
+ (instancetype)configureTimerView;

/// 初始化方法（自定义mode）
+ (instancetype)configureTimerViewWithMode:(CJJTimerViewMode)mode;

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
@property (nonatomic, assign) CGFloat timerViewHorizontalInset;
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
@property (nonatomic, assign, getter=isExistRightExtraView, readonly) BOOL existRightExtraView;

@end

NS_ASSUME_NONNULL_END
