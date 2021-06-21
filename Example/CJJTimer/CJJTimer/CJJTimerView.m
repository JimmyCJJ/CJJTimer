//
//  CJJTimerView.m
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

#import "CJJTimerView.h"
#import "CJJTimerMacro.h"
#import "CJJTimerTool.h"

#pragma mark -

typedef NS_ENUM(NSInteger, CJJTimerSuperViewType) {
    CJJTimerSuperViewType_Day = 101,
    CJJTimerSuperViewType_Hour,
    CJJTimerSuperViewType_Min,
    CJJTimerSuperViewType_Sec
};

@interface CJJTimerSuperView : UIView
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *colonLabel;
@property (nonatomic, strong) CJJTimerViewConfiguration *configuration;

- (instancetype)initWithConfiguration:(CJJTimerViewConfiguration *)configuration;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)resetTime;

- (CGFloat)timerViewWidth;
- (CGFloat)timerViewHeight;
- (CGFloat)timerColonWidth;
- (CGSize)viewSize;
//
- (void)setTimerViewBackgroundColor;
- (void)setTimerViewCornerRadius;
- (void)setTimerViewShadowColor;
- (void)setTimerViewShadowOffset;
- (void)setTimerViewShadowOpacity;
- (void)setTimerViewShadowRadius;
- (void)setTimerTextLabelColor;
- (void)setTimerColonLabelColor;
- (void)setTimerTextLabelFont;
- (void)setTimerColonLabelFont;
- (void)setTimerColonLabelTextWithType:(CJJTimerSuperViewType)type;
// 需子类实现
- (NSString *)timeLabelText;
- (NSString *)colonLabelText;
- (BOOL)viewShow;
- (BOOL)viewResetSize;
@end

@implementation CJJTimerSuperView

- (instancetype)initWithConfiguration:(CJJTimerViewConfiguration *)configuration
{
    _configuration = configuration;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLabel];
        [self addSubview:self.colonLabel];
    }
    return self;
}

#pragma mark - getter

- (CGFloat)timerViewWidth {
    return self.timeLabel.text.length > 0 ? self.configuration.timerViewWidth : 0;
}

- (CGFloat)timerViewHeight {
    return self.configuration.timerViewHeight;
}

- (CGSize)viewSize {
    if ([self viewShow]) {
        if ([self viewResetSize]) {
            self.timeLabel.frame = CGRectMake(0, 0, self.timerViewTextWidth, self.timerViewHeight);
            self.colonLabel.frame = CGRectMake(self.timerViewTextWidth, 0, self.timerColonWidth, self.timerViewHeight);
            return CGSizeMake(self.timerViewTextWidth + self.timerColonWidth, self.timerViewHeight);
        } else {
            self.timeLabel.frame = CGRectMake(0, 0, self.timerViewWidth, self.timerViewHeight);
            self.colonLabel.frame = CGRectMake(self.timerViewWidth, 0, self.timerColonWidth, self.timerViewHeight);
            return CGSizeMake(self.timerViewWidth + self.timerColonWidth, self.timerViewHeight);
        }
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)timerViewTextWidth {
    CGFloat height = [CJJTimerTool getLabelHeightWithString:@"test" Width:20 font:self.configuration.timerTextLabelFont];
    return [CJJTimerTool getLabelWidthWithString:self.timeLabel.text Height:height font:self.configuration.timerTextLabelFont]+4;
}

#pragma mark - setter

- (void)setTimerViewBackgroundColor {
    self.timeLabel.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
}

- (void)setTimerViewCornerRadius {
    self.timeLabel.layer.cornerRadius = self.configuration.timerViewCornerRadius;
}

- (void)setTimerViewShadowColor {
    self.timeLabel.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
}

- (void)setTimerViewShadowOffset {
    self.timeLabel.layer.shadowOffset = self.configuration.timerViewShadowOffset;
}

- (void)setTimerViewShadowOpacity {
    self.timeLabel.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
}

- (void)setTimerViewShadowRadius {
    self.timeLabel.layer.shadowRadius = self.configuration.timerViewShadowRadius;
}

- (void)setTimerTextLabelColor {
    self.timeLabel.textColor = self.configuration.timerTextLabelColor;
}

- (void)setTimerColonLabelColor {
    self.colonLabel.textColor = self.configuration.timerColonLabelColor;
}

- (void)setTimerTextLabelFont {
    self.timeLabel.font = self.configuration.timerTextLabelFont;
}

- (void)setTimerColonLabelFont {
    self.colonLabel.font = self.configuration.timerColonLabelFont;
}

- (void)setTimerColonLabelTextWithType:(CJJTimerSuperViewType)type {
    switch (type) {
        case CJJTimerSuperViewType_Day:
        {
            self.colonLabel.text = self.configuration.timerColonDayLabelText;
        }
            break;
        case CJJTimerSuperViewType_Hour:
        {
            self.colonLabel.text = self.configuration.timerColonHourLabelText;
        }
            break;
        case CJJTimerSuperViewType_Min:
        {
            self.colonLabel.text = self.configuration.timerColonMinLabelText;
        }
            break;
        case CJJTimerSuperViewType_Sec:
        {
            self.colonLabel.text = self.configuration.timerColonSecLabelText;
        }
            break;
    }
}

#pragma mark - sub class extend method

- (void)resetTime {
    CJJAbstractMethodNotImplemented();
}

- (NSString *)timeLabelText {
    CJJAbstractMethodNotImplemented();
}

- (NSString *)colonLabelText {
    CJJAbstractMethodNotImplemented();
}

- (BOOL)viewShow {
    CJJAbstractMethodNotImplemented();
}

- (BOOL)viewResetSize {
    CJJAbstractMethodNotImplemented();
}

- (CGFloat)timerColonWidth {
    CJJAbstractMethodNotImplemented();
}

#pragma mark - lazy

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = [self timeLabelText];
    }
    return _timeLabel;
}

- (UILabel *)colonLabel {
    if (!_colonLabel) {
        _colonLabel = [UILabel new];
        _colonLabel.textAlignment = NSTextAlignmentCenter;
        _colonLabel.text = [self colonLabelText];
    }
    return _colonLabel;
}

@end

#pragma mark - 天

@interface CJJTimerDayView : CJJTimerSuperView

@end

@implementation CJJTimerDayView

- (void)resetTime {
    self.timeLabel.text = @"00";
}

- (NSString *)timeLabelText {
    return @"00";
}

- (NSString *)colonLabelText {
    return @"天";
}

- (BOOL)viewShow {
    if (self.configuration.mode == CJJTimerViewMode_DHMS) {
        return YES;
    }
    return NO;
}

- (BOOL)viewResetSize {
    if (self.timeLabel.text.integerValue >= 100) {
        return YES;
    }
    return NO;
}

- (CGFloat)timerColonWidth {
    return self.colonLabel.text.length > 0 ? self.configuration.timerDayColonWidth : 0;
}

@end

#pragma mark - 时

@interface CJJTimerHourView : CJJTimerSuperView
@end

@implementation CJJTimerHourView

- (void)resetTime {
    self.timeLabel.text = @"00";
}

- (NSString *)timeLabelText {
    return @"00";
}

- (NSString *)colonLabelText {
    return @":";
}

- (BOOL)viewShow {
    if (self.configuration.mode == CJJTimerViewMode_DHMS ||
        self.configuration.mode == CJJTimerViewMode_HMS ||
        self.configuration.mode == CJJTimerViewMode_HM) {
        return YES;
    }
    return NO;
}

- (BOOL)viewResetSize {
    if (self.timeLabel.text.integerValue >= 100) {
        return YES;
    }
    return NO;
}

- (CGFloat)timerColonWidth {
    return self.colonLabel.text.length > 0 ? self.configuration.timerHourColonWidth : 0;
}

@end

#pragma mark - 分

@interface CJJTimerMinView : CJJTimerSuperView
@end

@implementation CJJTimerMinView

- (void)resetTime {
    self.timeLabel.text = @"00";
}

- (NSString *)timeLabelText {
    return @"00";
}

- (NSString *)colonLabelText {
    return @":";
}

- (BOOL)viewShow {
    if (self.configuration.mode == CJJTimerViewMode_DHMS ||
        self.configuration.mode == CJJTimerViewMode_HMS ||
        self.configuration.mode == CJJTimerViewMode_HM ||
       self.configuration.mode == CJJTimerViewMode_MS) {
        return YES;
    }
    return NO;
}

- (BOOL)viewResetSize {
    return NO;
}

- (CGFloat)timerColonWidth {
    return self.colonLabel.text.length > 0 ? self.configuration.timerMinColonWidth : 0;
}

@end

#pragma mark - 秒

@interface CJJTimerSecView : CJJTimerSuperView
@end

@implementation CJJTimerSecView

- (void)resetTime {
    self.timeLabel.text = @"00";
}

- (NSString *)timeLabelText {
    return @"00";
}

- (NSString *)colonLabelText {
    return @"";
}

- (BOOL)viewShow {
    if (self.configuration.mode == CJJTimerViewMode_DHMS ||
        self.configuration.mode == CJJTimerViewMode_HMS ||
       self.configuration.mode == CJJTimerViewMode_MS) {
        return YES;
    }
    return NO;
}

- (BOOL)viewResetSize {
    return NO;
}

- (CGFloat)timerColonWidth {
    return self.colonLabel.text.length > 0 ? self.configuration.timerSecColonWidth : 0;
}

@end

typedef NS_ENUM(NSInteger,CJJTimerViewType){
    CJJTimerView_TimerLabel = 1,
    CJJTimerView_ColonLabel
};

#pragma mark - CJJTimerView

static NSArray * CJJTimerViewObserverKeyPaths() {
    static NSArray *_CJJTimerViewObservedKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _CJJTimerViewObservedKeyPaths = @[@"timerLastTime", @"timerWidth", @"timerHeight", @"timerViewWidth", @"timerViewHeight", @"timerColonWidth", @"timerDayColonWidth", @"timerHourColonWidth", @"timerMinColonWidth", @"timerSecColonWidth", @"timerInsets", @"timerViewBackgroundColor", @"timerViewCornerRadius", @"timerViewShadowColor", @"timerViewShadowOffset", @"timerViewShadowOpacity", @"timerViewShadowRadius", @"timerTextLabelColor", @"timerColonLabelColor", @"timerTextLabelFont", @"timerColonLabelFont", @"timerColonDayLabelText", @"timerColonHourLabelText", @"timerColonMinLabelText", @"timerColonSecLabelText"];
    });
    return _CJJTimerViewObservedKeyPaths;
}

static void *CJJTimerViewObserverContext = &CJJTimerViewObserverContext;

@interface CJJTimerView ()<CJJTimerViewConfigurationDatasource>
@property (nonatomic, strong) CJJTimerSuperView *dayTimerView;
@property (nonatomic, strong) CJJTimerSuperView *hourTimerView;
@property (nonatomic, strong) CJJTimerSuperView *minTimerView;
@property (nonatomic, strong) CJJTimerSuperView *secTimerView;

@property (nonatomic, assign) CGFloat hourLabelastWidth;
@property (nonatomic, assign) CGFloat hourOriginWidth;
@property (nonatomic, assign, getter=isSubspend) BOOL subspend;
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@end

@implementation CJJTimerView

+ (instancetype)timerViewWithConfiguration:(CJJTimerViewConfiguration *)configuration {
    CJJTimerView *timer = [[CJJTimerView alloc] initWithFrame:CGRectZero];
    configuration.datasource = timer;
    timer.configuration = configuration;
    [timer setUp];
    return timer;
}

- (void)setUp {
    [self setObserveValue];
    [self setViews];
    [self setLayout];
    [self setDisplay];
    if (self.configuration.isTimerAutoStart) {
        [self startTimer];
    }
}

- (void)setObserveValue {
    for (NSString *keyPath in CJJTimerViewObserverKeyPaths()) {
        if ([self.configuration respondsToSelector:NSSelectorFromString(keyPath)]) {
            [self.configuration addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:CJJTimerViewObserverContext];
        }
    }
}

- (void)setViews {
    [self addSubview:self.dayTimerView];
    [self addSubview:self.hourTimerView];
    [self addSubview:self.minTimerView];
    [self addSubview:self.secTimerView];
    
    switch (self.configuration.mode) {
        case CJJTimerViewMode_HMS:
            //00-:-00-:-00 / 00-时-00-分-00-秒
            self.dayTimerView.hidden = YES;
            self.hourTimerView.hidden = NO;
            self.minTimerView.hidden = NO;
            self.secTimerView.hidden = NO;
            break;
        case CJJTimerViewMode_HM:
            //00-:-00 / 00-时-00-分
            self.dayTimerView.hidden = YES;
            self.hourTimerView.hidden = NO;
            self.minTimerView.hidden = NO;
            self.secTimerView.hidden = YES;
            break;
        case CJJTimerViewMode_MS:
            //00-:-00 / 00-分-00-秒
            self.dayTimerView.hidden = YES;
            self.hourTimerView.hidden = YES;
            self.minTimerView.hidden = NO;
            self.secTimerView.hidden = NO;
            break;
        case CJJTimerViewMode_DHMS:
            //0天-00-:-00-:-00 / 0-天-00-时-00-分-00-秒
            self.dayTimerView.hidden = NO;
            self.hourTimerView.hidden = NO;
            self.minTimerView.hidden = NO;
            self.secTimerView.hidden = NO;
            break;
    }
}

- (void)setLayout {
    self.dayTimerView.frame = CGRectMake(self.configuration.timerInsets.left, self.configuration.timerInsets.top, self.dayTimerView.viewSize.width, self.dayTimerView.viewSize.height);
    self.hourTimerView.frame = CGRectMake(CGRectGetMaxX(self.dayTimerView.frame), CGRectGetMinY(self.dayTimerView.frame), self.hourTimerView.viewSize.width, self.hourTimerView.viewSize.height);
    self.minTimerView.frame = CGRectMake(CGRectGetMaxX(self.hourTimerView.frame), CGRectGetMinY(self.dayTimerView.frame), self.minTimerView.viewSize.width, self.minTimerView.viewSize.height);
    self.secTimerView.frame = CGRectMake(CGRectGetMaxX(self.minTimerView.frame), CGRectGetMinY(self.dayTimerView.frame), self.secTimerView.viewSize.width, self.secTimerView.viewSize.height);
    
    SEL sel = NSSelectorFromString(@"caculateSize");
    if ([self.configuration respondsToSelector:sel]) {
        IMP imp = [self.configuration methodForSelector:sel];
        void (*func)(id, SEL) = (void (*)(id, SEL))imp;
        func(self.configuration, sel);
    }
}

- (void)setDisplay{
    [self displayViews:self.dayTimerView.timeLabel viewType:CJJTimerView_TimerLabel];
    [self displayViews:self.hourTimerView.timeLabel viewType:CJJTimerView_TimerLabel];
    [self displayViews:self.minTimerView.timeLabel viewType:CJJTimerView_TimerLabel];
    [self displayViews:self.secTimerView.timeLabel viewType:CJJTimerView_TimerLabel];
    
    [self displayViews:self.dayTimerView.colonLabel viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.hourTimerView.colonLabel viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.minTimerView.colonLabel viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.secTimerView.colonLabel viewType:CJJTimerView_ColonLabel];
}

- (void)displayViews:(UIView *)view viewType:(CJJTimerViewType)viewType{
    CJJTimerViewConfiguration *configuration = self.configuration;
    switch (viewType) {
        case CJJTimerView_TimerLabel:
        {
            UILabel *textLabel = (UILabel *)view;
            textLabel.layer.backgroundColor = configuration.timerViewBackgroundColor.CGColor;
            textLabel.layer.cornerRadius = configuration.timerViewCornerRadius;
            textLabel.layer.shadowColor = configuration.timerViewShadowColor.CGColor;
            textLabel.layer.shadowOffset = configuration.timerViewShadowOffset;
            textLabel.layer.shadowOpacity = configuration.timerViewShadowOpacity;
            textLabel.layer.shadowRadius = configuration.timerViewShadowRadius;
            textLabel.textColor = configuration.timerTextLabelColor;
            textLabel.font = configuration.timerTextLabelFont;
        }
            break;
        case CJJTimerView_ColonLabel:
        {
            UILabel *colonLabel = (UILabel *)view;
            colonLabel.textColor = configuration.timerColonLabelColor;
            colonLabel.font = configuration.timerColonLabelFont;
            if (colonLabel == self.dayTimerView.colonLabel) {
                colonLabel.text = configuration.timerColonDayLabelText;
            } else if (colonLabel == self.hourTimerView.colonLabel) {
                colonLabel.text = configuration.timerColonHourLabelText;
            } else if (colonLabel == self.minTimerView.colonLabel) {
                colonLabel.text = configuration.timerColonMinLabelText;
            } else if (colonLabel == self.secTimerView.colonLabel) {
                colonLabel.text = configuration.timerColonSecLabelText;
            }
        }
            break;
    }
}

- (void)configureLayout:(CJJTimerViewLayout)layout{
    layout(self.configuration.timerWidth, self.configuration.timerHeight);
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CJJTimerViewObserverContext) {
        if ([keyPath isEqualToString:@"timerLastTime"]) {
            [self startTimer];
            return;
        } else if ([keyPath isEqualToString:@"timerWidth"] || [keyPath isEqualToString:@"timerHeight"] || [keyPath isEqualToString:@"timerInsets"]) {
            if ([self.delegate respondsToSelector:@selector(changeModeInTimerView:)]) {
                [self.delegate changeModeInTimerView:self];
            }
            return;
        } else if ([keyPath isEqualToString:@"timerViewWidth"] || [keyPath isEqualToString:@"timerViewHeight"] || [keyPath isEqualToString:@"timerColonWidth"]) {
            [self setLayout];
            return;
        }
        
        if (!(keyPath.length > 1)) return;
        
        NSString *tempKeyPath = [keyPath substringFromIndex:1];
        NSString *selectorString = [NSString stringWithFormat:@"setT%@", tempKeyPath];
        if ([keyPath isEqualToString:@"timerViewBackgroundColor"] ||
            [keyPath isEqualToString:@"timerViewCornerRadius"] ||
            [keyPath isEqualToString:@"timerViewShadowColor"] ||
            [keyPath isEqualToString:@"timerViewShadowOffset"] ||
            [keyPath isEqualToString:@"timerViewShadowOpacity"] ||
            [keyPath isEqualToString:@"timerViewShadowRadius"] ||
            [keyPath isEqualToString:@"timerTextLabelColor"] ||
            [keyPath isEqualToString:@"timerColonLabelColor"] ||
            [keyPath isEqualToString:@"timerTextLabelFont"] ||
            [keyPath isEqualToString:@"timerColonLabelFont"]){
            [self timerViewPerformSelector:selectorString withObject:nil];
        } else if ([keyPath isEqualToString:@"timerColonDayLabelText"]) {
            [self timerColonLabelTextPerformSelector:keyPath withObject:@(CJJTimerSuperViewType_Day)];
        } else if ([keyPath isEqualToString:@"timerColonHourLabelText"]) {
            [self timerColonLabelTextPerformSelector:keyPath withObject:@(CJJTimerSuperViewType_Hour)];
        } else if ([keyPath isEqualToString:@"timerColonMinLabelText"]) {
            [self timerColonLabelTextPerformSelector:keyPath withObject:@(CJJTimerSuperViewType_Min)];
        } else if ([keyPath isEqualToString:@"timerColonSecLabelText"]) {
            [self timerColonLabelTextPerformSelector:keyPath withObject:@(CJJTimerSuperViewType_Sec)];
        } else if ([keyPath isEqualToString:@"timerDayColonWidth"] ||
                 [keyPath isEqualToString:@"timerHourColonWidth"] ||
                 [keyPath isEqualToString:@"timerMinColonWidth"] ||
                 [keyPath isEqualToString:@"timerSecColonWidth"]) {
            [self refreshLayout];
        }
    }
}

- (void)timerViewPerformSelector:(NSString *)selector withObject:(id)object {
    for (UIView *view in self.subviews) {
        SEL sel = NSSelectorFromString(selector);
        if ([view respondsToSelector:sel]) {
            IMP imp = [view methodForSelector:sel];
            void (*func)(id, SEL) = (void (*)(id, SEL))imp;
            func(view, sel);
        }
    }
}

- (void)timerColonLabelTextPerformSelector:(NSString *)selector withObject:(id)object {
    if ([selector isEqualToString:@"timerColonDayLabelText"]) {
        [self.dayTimerView setTimerColonLabelTextWithType:[object integerValue]];
    } else if ([selector isEqualToString:@"timerColonHourLabelText"]) {
        [self.hourTimerView setTimerColonLabelTextWithType:[object integerValue]];
    } else if ([selector isEqualToString:@"timerColonMinLabelText"]) {
        [self.minTimerView setTimerColonLabelTextWithType:[object integerValue]];
    } else if ([selector isEqualToString:@"timerColonSecLabelText"]) {
        [self.secTimerView setTimerColonLabelTextWithType:[object integerValue]];
    }
}

#pragma mark - CJJTimerViewConfigurationDatasource

- (CGFloat)timerViewWidthInConfiguration:(CJJTimerViewConfiguration *)configuration {
    return CGRectGetMaxX(self.secTimerView.frame) + configuration.timerInsets.right;
}

#pragma mark - logic

/// 开启定时器
- (dispatch_source_t)startTimer {
    self.hidden = NO;
    //先赋值一次
    BOOL valid = [self refreshView];
    //GCD定时器
    return valid ? self.dispatchTimer : nil;
}

/// 销毁定时器
- (void)stopTimer {
    if (_dispatchTimer) {
        if (_subspend) {
            [self resumeTimer];
        }
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
        
    }
    [self timerViewPerformSelector:@"resetTime" withObject:nil];
    if (_configuration.isTimerHiddenWhenFinished) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

/// 暂停定时器
- (void)suspendTimer {
    if (_dispatchTimer && !_subspend) {
        dispatch_suspend(_dispatchTimer);
        self.subspend = YES;
    }
}

/// 恢复定时器
- (void)resumeTimer {
    if (_dispatchTimer && _subspend) {
        dispatch_resume(_dispatchTimer);
        _subspend = NO;
    }
}

/// 重置定时器（传时间戳）
- (void)resetTimerWithlastTime:(NSString *)lastTime {
    self.configuration.timerLastTime = lastTime;
}

#pragma mark - refresh UI

- (BOOL)refreshView {
    
    //获取当前时间戳
    NSString *currentStamp = [CJJTimerTool getNowTimeTimeStampSec];
    NSString *endStamp = self.configuration.timerLastTime;
    
    NSDateComponents *compareDate = [CJJTimerTool startTimeStamp:currentStamp endTimeStamp:endStamp format:[self getTimerToolFormat]];
    if (self.mode != CJJTimerViewMode_DHMS) {
        compareDate.day = 0;
    }
    
    return [self refreshViewWithDateComponents:compareDate];
}

- (BOOL)refreshViewWithDateComponents:(NSDateComponents *)dateComponents {
    if ([self refreshViewShouldStopWithDateComponents:dateComponents]) {
        [self stopTimer];
        
        if ([self.delegate respondsToSelector:@selector(timerFinishedInTimerView:)]) {
            [self.delegate timerFinishedInTimerView:self];
        }
        
        return NO;
    }
    
    [self refreshViewTextWithTimerView:self.dayTimerView time:dateComponents.day];
    [self refreshViewTextWithTimerView:self.hourTimerView time:dateComponents.hour];
    [self refreshViewTextWithTimerView:self.minTimerView time:dateComponents.minute];
    [self refreshViewTextWithTimerView:self.secTimerView time:dateComponents.second];
    
    [self refreshLayout];
    
    return YES;
}

- (BOOL)refreshViewShouldStopWithDateComponents:(NSDateComponents *)dateComponents {
    BOOL result = NO;
    switch (self.configuration.mode) {
        case CJJTimerViewMode_DHMS:
            result = dateComponents.day <= 0 && dateComponents.hour <= 0 && dateComponents.minute <= 0 && dateComponents.second <= 0;
            break;
        case CJJTimerViewMode_HMS:
        case CJJTimerViewMode_HM:
        case CJJTimerViewMode_MS:
            result = dateComponents.hour <= 0 && dateComponents.minute <= 0 && dateComponents.second <= 0;
            break;
        default:
            result = YES;
            break;
    }
    
    return result;
}

- (void)refreshViewTextWithTimerView:(CJJTimerSuperView *)timerView time:(NSInteger)time {
    if (time < 10) {
        if (self.configuration.timerAutoChangeMode && time <= 0) {
            if (self.configuration.mode == CJJTimerViewMode_DHMS &&
                [timerView isKindOfClass:[CJJTimerDayView class]] &&
                self.hourTimerView.timeLabel.text.integerValue <= 0 &&
                self.minTimerView.timeLabel.text.integerValue <= 0 &&
                self.secTimerView.timeLabel.text.integerValue <= 0) {
                self.dayTimerView.hidden = YES;
                [self.configuration changeMode:CJJTimerViewMode_HMS];
            } else if (self.configuration.mode == CJJTimerViewMode_HMS &&
                       [timerView isKindOfClass:[CJJTimerHourView class]] &&
                       self.minTimerView.timeLabel.text.integerValue <= 0 &&
                       self.secTimerView.timeLabel.text.integerValue <= 0) {
                self.hourTimerView.hidden = YES;
                [self.configuration changeMode:CJJTimerViewMode_MS];
            }
        }
        timerView.timeLabel.text = [NSString stringWithFormat:@"0%ld",(long)time];
    } else {
        timerView.timeLabel.text = [NSString stringWithFormat:@"%ld",(long)time];
    }
}

#pragma mark - refersh layout

- (void)refreshLayout {
    [self setLayout];
}

- (CJJTimerViewMode)mode {
    return self.configuration.mode;
}

- (CJJTimerToolFormat)getTimerToolFormat {
    CJJTimerToolFormat result;
    switch (self.configuration.mode) {
        case CJJTimerViewMode_DHMS:
            result = CJJTimerToolFormat_Day;
            break;
        case CJJTimerViewMode_HMS:
            result = CJJTimerToolFormat_Hour;
            break;
        case CJJTimerViewMode_HM:
            result = CJJTimerToolFormat_Hour;
            break;
        case CJJTimerViewMode_MS:
            result = CJJTimerToolFormat_Hour;
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark - lazy

- (dispatch_source_t)dispatchTimer {
    if (!_dispatchTimer) {
        CJJWeakSelf(self)
        _dispatchTimer = CJJTimerViewCreateDispatchTimer(1.0*NSEC_PER_SEC, 0, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                CJJStrongSelf(self)
                [strongself refreshView];
            });
        });
    }
    return _dispatchTimer;
}

dispatch_source_t CJJTimerViewCreateDispatchTimer(uint64_t interval,
                                                  uint64_t leeway,
                                                  dispatch_queue_t queue,
                                                  dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (CJJTimerSuperView *)dayTimerView {
    if (!_dayTimerView) {
        _dayTimerView = [[CJJTimerDayView alloc] initWithConfiguration:self.configuration];
    }
    return _dayTimerView;
}

- (CJJTimerSuperView *)hourTimerView {
    if (!_hourTimerView) {
        _hourTimerView = [[CJJTimerHourView alloc] initWithConfiguration:self.configuration];
    }
    return _hourTimerView;
}

- (CJJTimerSuperView *)minTimerView {
    if (!_minTimerView) {
        _minTimerView = [[CJJTimerMinView alloc] initWithConfiguration:self.configuration];
    }
    return _minTimerView;
}

- (CJJTimerSuperView *)secTimerView {
    if (!_secTimerView) {
        _secTimerView = [[CJJTimerSecView alloc] initWithConfiguration:self.configuration];
    }
    return _secTimerView;
}

#pragma mark - deadline

- (void)dealloc {
    NSLog(@"CJJTimer销毁");
    [self stopTimer];
    for (NSString *keyPath in CJJTimerViewObserverKeyPaths()) {
        if ([self.configuration respondsToSelector:NSSelectorFromString(keyPath)]) {
            [self.configuration removeObserver:self forKeyPath:keyPath context:CJJTimerViewObserverContext];
        }
    }
}

@end

