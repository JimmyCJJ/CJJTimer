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
#import "CJJTimerViewConfiguration.h"
#import "CJJTimerViewConfiguration+Invoke.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CJJTimerViewLayout)(CGFloat timerWidth, CGFloat timerHeight);

@class CJJTimerView;
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

NS_ASSUME_NONNULL_END
