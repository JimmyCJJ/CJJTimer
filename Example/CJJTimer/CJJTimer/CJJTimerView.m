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
#import "Masonry.h"

typedef NS_ENUM(NSInteger,CJJTimerViewType){
    CJJTimerView_TimerView = 1,
    CJJTimerView_TextLabel,
    CJJTimerView_ColonLabel
};

#pragma mark - CJJTimerView

static NSArray * CJJTimerViewObserverKeyPaths() {
    static NSArray *_CJJTimerViewObservedKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _CJJTimerViewObservedKeyPaths = @[@"timerLastTime",@"timerWidth",@"timerHeight",@"timerViewWidth",@"timerViewHeight",@"timerViewInset",@"timerColonWidth",@"timerInsets",@"timerViewBackgroundColor",@"timerViewCornerRadius",@"timerViewShadowColor",@"timerViewShadowOffset",@"timerViewShadowOpacity",@"timerViewShadowRadius",@"timerTextLabelColor",@"timerColonLabelColor",@"timerTextLabelFont",@"timerColonLabelFont",@"timerColonHourLabelText",@"timerColonMinLabelText",@"timerColonSecLabelText"];
    });
    return _CJJTimerViewObservedKeyPaths;
}

static void *CJJTimerViewObserverContext = &CJJTimerViewObserverContext;

@interface CJJTimerView ()
@property (nonatomic, strong) UIView *hourView;
@property (nonatomic, strong) UIView *minView;
@property (nonatomic, strong) UIView *secView;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secLabel;
@property (nonatomic, strong) UILabel *hourColonLabel;
@property (nonatomic, strong) UILabel *minColonLabel;
@property (nonatomic, strong) UILabel *secColonLabel;

@property (nonatomic, assign) CGFloat hourLabelastWidth;
@property (nonatomic, assign) CGFloat hourOriginWidth;
@property (nonatomic, assign, getter=isSubspend) BOOL subspend;
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@end

@implementation CJJTimerView

+ (instancetype)timerViewWithConfiguration:(CJJTimerViewConfiguration *)configuration{
    CJJTimerView *timer = [[CJJTimerView alloc] initWithFrame:CGRectZero];
    timer.configuration = configuration;
    [timer setUp];
    return timer;
}

- (void)setUp{
    [self setObserveValue];
    [self setViews];
    [self setDisplay];
    [self setLayout];
    if(self.configuration.isTimerAutoStart){
        [self startTimer];
    }
}

- (void)setObserveValue{
    for (NSString *keyPath in CJJTimerViewObserverKeyPaths()) {
        if([self.configuration respondsToSelector:NSSelectorFromString(keyPath)]){
            [self.configuration addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:CJJTimerViewObserverContext];
        }
    }
}

- (void)setViews{
    [self addSubview:self.hourView];
    [self addSubview:self.minView];
    [self addSubview:self.secView];
    [self.hourView addSubview:self.hourLabel];
    [self.minView addSubview:self.minLabel];
    [self.secView addSubview:self.secLabel];
    [self addSubview:self.hourColonLabel];
    [self addSubview:self.minColonLabel];
    [self addSubview:self.secColonLabel];
    
    switch (self.configuration.mode) {
        case CJJTimerViewMode_HMS:
            //00-:-00-:-00 / 00-时-00-分-00-秒
            self.hourView.hidden = NO;
            self.minView.hidden = NO;
            self.secView.hidden = NO;
            self.hourColonLabel.hidden = NO;
            self.minColonLabel.hidden = NO;
            self.secColonLabel.hidden = NO;
            break;
        case CJJTimerViewMode_HM:
            //00-:-00 / 00-时-00-分
            self.hourView.hidden = NO;
            self.minView.hidden = NO;
            self.secView.hidden = YES;
            self.hourColonLabel.hidden = NO;
            self.minColonLabel.hidden = NO;
            self.secColonLabel.hidden = YES;
            break;
        case CJJTimerViewMode_MS:
            //00-:-00 / 00-分-00-秒
            self.hourView.hidden = YES;
            self.minView.hidden = NO;
            self.secView.hidden = NO;
            self.hourColonLabel.hidden = NO;
            self.minColonLabel.hidden = NO;
            self.secColonLabel.hidden = NO;
            break;
    }
}

- (void)setDisplay{
    [self displayViews:self.hourView viewType:CJJTimerView_TimerView];
    [self displayViews:self.minView viewType:CJJTimerView_TimerView];
    [self displayViews:self.secView viewType:CJJTimerView_TimerView];
    [self displayViews:self.hourLabel viewType:CJJTimerView_TextLabel];
    [self displayViews:self.minLabel viewType:CJJTimerView_TextLabel];
    [self displayViews:self.secLabel viewType:CJJTimerView_TextLabel];
    [self displayViews:self.hourColonLabel viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.minColonLabel viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.secColonLabel viewType:CJJTimerView_ColonLabel];
}

- (void)displayViews:(UIView *)view viewType:(CJJTimerViewType)viewType{
    CJJTimerViewConfiguration *configuration = self.configuration;
    switch (viewType) {
        case CJJTimerView_TimerView:
        {
            view.layer.backgroundColor = configuration.timerViewBackgroundColor.CGColor;
            view.layer.cornerRadius = configuration.timerViewCornerRadius;
            view.layer.shadowColor = configuration.timerViewShadowColor.CGColor;
            view.layer.shadowOffset = configuration.timerViewShadowOffset;
            view.layer.shadowOpacity = configuration.timerViewShadowOpacity;
            view.layer.shadowRadius = configuration.timerViewShadowRadius;
        }
            break;
        case CJJTimerView_TextLabel:
        {
            UILabel *textLabel = (UILabel *)view;
            textLabel.textColor = configuration.timerTextLabelColor;
            textLabel.font = configuration.timerTextLabelFont;
        }
            break;
        case CJJTimerView_ColonLabel:
        {
            UILabel *colonLabel = (UILabel *)view;
            colonLabel.textColor = configuration.timerColonLabelColor;
            colonLabel.font = configuration.timerColonLabelFont;
            if(colonLabel == self.hourColonLabel){
                colonLabel.text = configuration.timerColonHourLabelText;
            }else if (colonLabel == self.minColonLabel){
                colonLabel.text = configuration.timerColonMinLabelText;
            }else if (colonLabel == self.secColonLabel){
                colonLabel.text = configuration.timerColonSecLabelText;
            }
        }
            break;
    }
}

- (void)setLayout{
    
    [_secColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-self.configuration.timerInsets.right);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
        if(self.configuration.isExistRightExtraView){
            make.width.mas_equalTo(self.configuration.timerColonWidth);
        }else{
            make.width.mas_equalTo(0);
        }
    }];
    
    [_secView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.configuration.isExistRightExtraView){
            make.right.mas_equalTo(_secColonLabel.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }else{
            make.right.mas_equalTo(_secColonLabel.mas_left);
        }
        if(self.configuration.mode == CJJTimerViewMode_HM){
            make.width.mas_equalTo(0);
        }else{
            make.width.mas_equalTo(self.configuration.timerViewWidth);
        }
        make.top.bottom.mas_equalTo(_secColonLabel);
        make.centerY.mas_equalTo(_secColonLabel);
    }];
    
    [_minColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secColonLabel);
        if(self.configuration.mode == CJJTimerViewMode_HM){
            if([self NullStr:_minColonLabel.text]){
                make.width.mas_equalTo(0);
            }else{
                make.width.mas_equalTo(self.configuration.timerColonWidth);
            }
            make.right.mas_equalTo(_secView.mas_left);
        }else{
            make.width.mas_equalTo(self.configuration.timerColonWidth);
            make.right.mas_equalTo(_secView.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];
    
    [_minView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.configuration.mode == CJJTimerViewMode_HM){
            if([self NullStr:_minColonLabel.text]){
                make.right.mas_equalTo(_minColonLabel.mas_left);
            }else{
                make.right.mas_equalTo(_minColonLabel.mas_left).offset(-self.configuration.timerViewHorizontalInset);
            }
        }else{
            make.right.mas_equalTo(_minColonLabel.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }
        make.centerY.mas_equalTo(_secColonLabel);
        make.width.mas_equalTo(self.configuration.timerViewWidth);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];
    
    [_hourColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secColonLabel);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
        if(self.configuration.mode == CJJTimerViewMode_MS){
            make.right.mas_equalTo(_minView.mas_left);
            make.width.mas_equalTo(0);
        }else{
            make.right.mas_equalTo(_minView.mas_left).offset(-self.configuration.timerViewHorizontalInset);
            make.width.mas_equalTo(self.configuration.timerColonWidth);
        }
    }];
    
    [_hourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secColonLabel);
        if(self.configuration.mode == CJJTimerViewMode_MS){
            make.width.mas_equalTo(0);
            make.right.mas_equalTo(_hourColonLabel.mas_left);
        }else{
            make.width.mas_equalTo(self.configuration.timerViewWidth);
            make.right.mas_equalTo(_hourColonLabel.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];

    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [_minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [_secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)configureLayout:(CJJTimerViewLayout)layout{
    layout(self.configuration.timerWidth, self.configuration.timerHeight);
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CJJTimerViewObserverContext) {
        if([keyPath isEqualToString:@"timerLastTime"]){
            [self startTimer];
        }else if ([keyPath isEqualToString:@"timerWidth"] || [keyPath isEqualToString:@"timerHeight"]|| [keyPath isEqualToString:@"timerViewInset"] || [keyPath isEqualToString:@"timerInsets"]){
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.configuration.timerWidth);
                make.height.mas_equalTo(self.configuration.timerHeight);
            }];
        }else if ([keyPath isEqualToString:@"timerViewWidth"]){
            [self.hourView mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_MS){
                    make.width.mas_equalTo(0);
                }else{
                    make.width.mas_equalTo(self.configuration.timerViewWidth);
                }
            }];
            
            [self.minView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.configuration.timerViewWidth);
            }];
            
            [self.secView mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_HM){
                    make.width.mas_equalTo(0);
                }else{
                    make.width.mas_equalTo(self.configuration.timerViewWidth);
                }
            }];
        }else if ([keyPath isEqualToString:@"timerViewHeight"]){
            [self.hourView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.configuration.timerViewHeight);
            }];
            
            [self.minView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.configuration.timerViewHeight);
            }];
            
            [self.secView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.configuration.timerViewHeight);
            }];
        }else if ([keyPath isEqualToString:@"timerColonWidth"]){
            [_hourColonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_MS){
                    make.width.mas_equalTo(0);
                }else{
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }
            }];
            
            [_minColonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_HM){
                    if([self NullStr:_minColonLabel.text]){
                        make.width.mas_equalTo(0);
                    }else{
                        make.width.mas_equalTo(self.configuration.timerColonWidth);
                    }
                }else{
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }
            }];
            
            [_secColonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.isExistRightExtraView){
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }else{
                    make.width.mas_equalTo(0);
                }
            }];
        }else if ([keyPath isEqualToString:@"timerViewBackgroundColor"]){
            self.hourView.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
            self.minView.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
            self.secView.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
        }else if ([keyPath isEqualToString:@"timerViewCornerRadius"]){
            self.hourView.layer.cornerRadius = self.configuration.timerViewCornerRadius;
            self.minView.layer.cornerRadius = self.configuration.timerViewCornerRadius;
            self.secView.layer.cornerRadius = self.configuration.timerViewCornerRadius;
        }else if ([keyPath isEqualToString:@"timerViewShadowColor"]){
            self.hourView.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
            self.minView.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
            self.secView.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
        }else if ([keyPath isEqualToString:@"timerViewShadowOffset"]){
            self.hourView.layer.shadowOffset = self.configuration.timerViewShadowOffset;
            self.minView.layer.shadowOffset = self.configuration.timerViewShadowOffset;
            self.secView.layer.shadowOffset = self.configuration.timerViewShadowOffset;
        }else if ([keyPath isEqualToString:@"timerViewShadowOpacity"]){
            self.hourView.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
            self.minView.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
            self.secView.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
        }else if ([keyPath isEqualToString:@"timerViewShadowRadius"]){
            self.hourView.layer.shadowRadius = self.configuration.timerViewShadowRadius;
            self.minView.layer.shadowRadius = self.configuration.timerViewShadowRadius;
            self.secView.layer.shadowRadius = self.configuration.timerViewShadowRadius;
        }else if ([keyPath isEqualToString:@"timerTextLabelColor"]){
            self.hourLabel.textColor = self.configuration.timerTextLabelColor;
            self.minLabel.textColor = self.configuration.timerTextLabelColor;
            self.secLabel.textColor = self.configuration.timerTextLabelColor;
        }else if ([keyPath isEqualToString:@"timerColonLabelColor"]){
            self.hourColonLabel.textColor = self.configuration.timerColonLabelColor;
            self.minColonLabel.textColor = self.configuration.timerColonLabelColor;
        }else if ([keyPath isEqualToString:@"timerTextLabelFont"]){
            self.hourLabel.font = self.configuration.timerTextLabelFont;
            self.minLabel.font = self.configuration.timerTextLabelFont;
            self.secLabel.font = self.configuration.timerTextLabelFont;
        }else if ([keyPath isEqualToString:@"timerColonLabelFont"]){
            self.hourColonLabel.font = self.configuration.timerColonLabelFont;
            self.minColonLabel.font = self.configuration.timerColonLabelFont;
            self.secColonLabel.font = self.configuration.timerColonLabelFont;
        }else if ([keyPath isEqualToString:@"timerColonHourLabelText"]){
            self.hourColonLabel.text = self.configuration.timerColonHourLabelText;
        }else if ([keyPath isEqualToString:@"timerColonMinLabelText"]){
            self.minColonLabel.text = self.configuration.timerColonMinLabelText;
        }else if ([keyPath isEqualToString:@"timerColonSecLabelText"]){
            self.secColonLabel.text = self.configuration.timerColonSecLabelText;
            [_secColonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.isExistRightExtraView){
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }else{
                    make.width.mas_equalTo(0);
                }
            }];
            
            [_secView mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.isExistRightExtraView){
                    make.right.mas_equalTo(_secColonLabel.mas_left).offset(-self.configuration.timerViewHorizontalInset);
                }else{
                    make.right.mas_equalTo(_secColonLabel.mas_left).offset(0);
                }
            }];
        }
    }
}

#pragma mark - logic

/// 开启定时器
- (dispatch_source_t)startTimer{
    self.hidden = NO;
    //先赋值一次
    BOOL valid = [self refreshView];
    //GCD定时器
    return valid?self.dispatchTimer:nil;
}

/// 销毁定时器
- (void)stopTimer{
    if(_dispatchTimer){
        if(_subspend){
            [self resumeTimer];
        }
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
        
    }
    _hourLabel.text = @"00";
    _minLabel.text = @"00";
    _secLabel.text = @"00";
    if(_configuration.isTimerHiddenWhenFinished){
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}

/// 暂停定时器
- (void)suspendTimer{
    if(_dispatchTimer && !_subspend){
        dispatch_suspend(_dispatchTimer);
        self.subspend = YES;
    }
}

/// 恢复定时器
- (void)resumeTimer{
    if(_dispatchTimer && _subspend){
        dispatch_resume(_dispatchTimer);
        _subspend = NO;
    }
}

/// 重置定时器（传时间戳）
- (void)resetTimerWithlastTime:(NSString *)lastTime{
    self.configuration.timerLastTime = lastTime;
}

#pragma mark - refresh UI

- (BOOL)refreshView{
    
    //获取当前时间戳
    NSString *currentStamp = [self getNowTimeTimeStampSec];
    NSString *endStamp = self.configuration.timerLastTime;
    
    NSDateComponents *compareDate = [self startTimeStamp:currentStamp endTimeStamp:endStamp];
    
    NSInteger lastHour = compareDate.hour;
    NSInteger lastMinute = compareDate.minute;
    NSInteger lastSecond = compareDate.second;
    
    if(lastHour < 0 || lastMinute < 0 || lastSecond < 0 || (lastHour <= 0 && lastMinute <= 0 && lastSecond <= 0) ){
        [self stopTimer];
        
        if([self.delegate respondsToSelector:@selector(timerFinished:)]){
            [self.delegate timerFinished:self];
        }
        
        return NO;
    }
    
    if(lastHour < 10){
        self.hourLabel.text = [NSString stringWithFormat:@"0%ld",(long)lastHour];
    }else{
        self.hourLabel.text = [NSString stringWithFormat:@"%ld",(long)lastHour];
    }
    
    if(lastMinute < 10){
        self.minLabel.text = [NSString stringWithFormat:@"0%ld",(long)lastMinute];
    }else{
        self.minLabel.text = [NSString stringWithFormat:@"%ld",(long)lastMinute];
    }
    
    if(lastSecond < 10){
        self.secLabel.text = [NSString stringWithFormat:@"0%ld",(long)lastSecond];
    }else{
        self.secLabel.text = [NSString stringWithFormat:@"%ld",(long)lastSecond];
    }
    
    [self refreshLayout];
    
    return YES;
}

- (NSDateComponents *)startTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp
{
    //东八区-北京时间
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    // 两个时间戳转换日期类
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:[startTimeStamp doubleValue] + delta];
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:[endTimeStamp doubleValue] + delta];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:startDate toDate:endDate options:0];
//    NSLog(@"剩余%ld天,%ld小时%ld分%ld秒", cmps.day ,cmps.hour, cmps.minute, cmps.second);
    return cmps;
}

////返回秒为单位的时间戳
- (NSString *)getNowTimeTimeStampSec{

    NSDate *datenow = [NSDate date];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;

}

//返回毫秒为单位的时间戳
- (NSString *)getNowTimeTimestampMinSec{
    
    NSDate *datenow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    
    return timeSp;
}

#pragma mark - refersh layout

- (void)refreshLayout{
    if(self.hourLabel.text.floatValue >= 100){
        CGFloat oneLineH = [self getLabelHeightWithString:@"one" Width:20 font:self.configuration.timerTextLabelFont];
        CGFloat hourW = [self getLabelWidthWithString:self.hourLabel.text Height:oneLineH font:self.configuration.timerTextLabelFont]+5;
        
        if(self.hourLabelastWidth > 0){
            if(self.hourLabelastWidth != hourW){
                if(self.configuration.mode == CJJTimerViewMode_MS){
                    hourW = 0;
                }
                self.hourLabelastWidth = hourW;
                [_hourView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(hourW);
                }];
            }
        }else{
            if(self.configuration.mode == CJJTimerViewMode_MS){
                hourW = 0;
            }
            self.hourLabelastWidth = hourW;
            [_hourView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(hourW);
            }];
        }
    }else{
        if(self.configuration.mode == CJJTimerViewMode_MS){
            self.hourLabelastWidth = 0;
        }else{
            self.hourLabelastWidth = self.configuration.timerViewWidth;
        }
        [_hourView mas_updateConstraints:^(MASConstraintMaker *make) {
            if(self.configuration.mode == CJJTimerViewMode_MS){
                make.width.mas_equalTo(0);
            }else{
                make.width.mas_equalTo(self.configuration.timerViewWidth);
            }
        }];
    }
}

- (CGFloat)getLabelHeightWithString:(NSString *)string Width:(CGFloat)width font:(UIFont *)font
{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                   
                                     options:NSStringDrawingUsesLineFragmentOrigin
                   
                                  attributes:@{NSFontAttributeName:font} context:nil];
    
    
    return rect.size.height;
    
}

- (CGFloat)getLabelWidthWithString:(NSString *)string Height:(CGFloat)height font:(UIFont *)font{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                   
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                   
                                     context:nil];
    return rect.size.width;
}

#pragma mark - private

- (BOOL)NullStr:(NSString *)str{
    if (!str) {
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (!str.length) {
        return YES;
    }

    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

#pragma mark - setter

- (void)setHourLastWidth:(CGFloat)hourLabelastWidth{
    _hourLabelastWidth = hourLabelastWidth;
    if(_hourLabelastWidth > self.configuration.timerViewWidth){
        if(self.hourOriginWidth == 0){
            self.hourOriginWidth = self.configuration.timerWidth;
        }
        [self.configuration setValue:@(self.hourOriginWidth + (_hourLabelastWidth - self.configuration.timerViewWidth)) forKey:@"timerWidth"];
    }
}

#pragma mark - lazy

- (dispatch_source_t)dispatchTimer{
    if(!_dispatchTimer){
        kWeakSelf(self)
        _dispatchTimer = CJJTimerViewCreateDispatchTimer(1.0*NSEC_PER_SEC, 0, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                kStrongSelf(self)
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

- (UIView *)hourView{
    if(!_hourView){
        _hourView = [UIView new];
    }
    return _hourView;
}

- (UIView *)minView{
    if(!_minView){
        _minView = [UIView new];
    }
    return _minView;
}

- (UIView *)secView{
    if(!_secView){
        _secView = [UIView new];
    }
    return _secView;
}

- (UILabel *)hourLabel{
    if(!_hourLabel){
        _hourLabel = [UILabel new];
        _hourLabel.text = @"00";
        _hourLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hourLabel;
}

- (UILabel *)minLabel{
    if(!_minLabel){
        _minLabel = [UILabel new];
        _minLabel.text = @"00";
        _minLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _minLabel;
}

- (UILabel *)secLabel{
    if(!_secLabel){
        _secLabel = [UILabel new];
        _secLabel.text = @"00";
        _secLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secLabel;
}

- (UILabel *)hourColonLabel{
    if(!_hourColonLabel){
        _hourColonLabel = [UILabel new];
        _hourColonLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hourColonLabel;
}

- (UILabel *)minColonLabel{
    if(!_minColonLabel){
        _minColonLabel = [UILabel new];
        _minColonLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _minColonLabel;
}

- (UILabel *)secColonLabel{
    if(!_secColonLabel){
        _secColonLabel = [UILabel new];
        _secColonLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secColonLabel;
}

#pragma mark - deadline

- (void)dealloc{
    NSLog(@"CJJTimer销毁");
    [self stopTimer];
    for (NSString *keyPath in CJJTimerViewObserverKeyPaths()) {
        if([self.configuration respondsToSelector:NSSelectorFromString(keyPath)]){
            [self.configuration removeObserver:self forKeyPath:keyPath context:CJJTimerViewObserverContext];
        }
    }
}


@end


