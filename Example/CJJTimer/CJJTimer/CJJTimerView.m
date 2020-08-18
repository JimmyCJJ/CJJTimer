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
@property (nonatomic, strong) UIView *hourV;
@property (nonatomic, strong) UIView *minV;
@property (nonatomic, strong) UIView *secV;
@property (nonatomic, strong) UILabel *hourL;
@property (nonatomic, strong) UILabel *minL;
@property (nonatomic, strong) UILabel *secL;
@property (nonatomic, strong) UILabel *hourColonL;
@property (nonatomic, strong) UILabel *minColonL;
@property (nonatomic, strong) UILabel *secColonL;

@property (nonatomic, assign) CGFloat hourLastWidth;
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
    [self addSubview:self.hourV];
    [self addSubview:self.minV];
    [self addSubview:self.secV];
    [self.hourV addSubview:self.hourL];
    [self.minV addSubview:self.minL];
    [self.secV addSubview:self.secL];
    [self addSubview:self.hourColonL];
    [self addSubview:self.minColonL];
    [self addSubview:self.secColonL];
    
    switch (self.configuration.mode) {
        case CJJTimerViewMode_HMS:
            //00-:-00-:-00 / 00-时-00-分-00-秒
            self.hourV.hidden = NO;
            self.minV.hidden = NO;
            self.secV.hidden = NO;
            self.hourColonL.hidden = NO;
            self.minColonL.hidden = NO;
            self.secColonL.hidden = NO;
            break;
        case CJJTimerViewMode_HM:
            //00-:-00 / 00-时-00-分
            self.hourV.hidden = NO;
            self.minV.hidden = NO;
            self.secV.hidden = YES;
            self.hourColonL.hidden = NO;
            self.minColonL.hidden = NO;
            self.secColonL.hidden = YES;
            break;
        case CJJTimerViewMode_MS:
            //00-:-00 / 00-分-00-秒
            self.hourV.hidden = YES;
            self.minV.hidden = NO;
            self.secV.hidden = NO;
            self.hourColonL.hidden = NO;
            self.minColonL.hidden = NO;
            self.secColonL.hidden = NO;
            break;
    }
}

- (void)setDisplay{
    [self displayViews:self.hourV viewType:CJJTimerView_TimerView];
    [self displayViews:self.minV viewType:CJJTimerView_TimerView];
    [self displayViews:self.secV viewType:CJJTimerView_TimerView];
    [self displayViews:self.hourL viewType:CJJTimerView_TextLabel];
    [self displayViews:self.minL viewType:CJJTimerView_TextLabel];
    [self displayViews:self.secL viewType:CJJTimerView_TextLabel];
    [self displayViews:self.hourColonL viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.minColonL viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.secColonL viewType:CJJTimerView_ColonLabel];
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
            if(colonLabel == self.hourColonL){
                colonLabel.text = configuration.timerColonHourLabelText;
            }else if (colonLabel == self.minColonL){
                colonLabel.text = configuration.timerColonMinLabelText;
            }else if (colonLabel == self.secColonL){
                colonLabel.text = configuration.timerColonSecLabelText;
            }
        }
            break;
    }
}

- (void)setLayout{
    
    [_secColonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-self.configuration.timerInsets.right);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
        if(self.configuration.isExistRightExtraView){
            make.width.mas_equalTo(self.configuration.timerColonWidth);
        }else{
            make.width.mas_equalTo(0);
        }
    }];
    
    [_secV mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.configuration.isExistRightExtraView){
            make.right.mas_equalTo(_secColonL.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }else{
            make.right.mas_equalTo(_secColonL.mas_left);
        }
        if(self.configuration.mode == CJJTimerViewMode_HM){
            make.width.mas_equalTo(0);
        }else{
            make.width.mas_equalTo(self.configuration.timerViewWidth);
        }
        make.top.bottom.mas_equalTo(_secColonL);
        make.centerY.mas_equalTo(_secColonL);
    }];
    
    [_minColonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secColonL);
        if(self.configuration.mode == CJJTimerViewMode_HM){
            if([self NullStr:_minColonL.text]){
                make.width.mas_equalTo(0);
            }else{
                make.width.mas_equalTo(self.configuration.timerColonWidth);
            }
            make.right.mas_equalTo(_secV.mas_left);
        }else{
            make.width.mas_equalTo(self.configuration.timerColonWidth);
            make.right.mas_equalTo(_secV.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];
    
    [_minV mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.configuration.mode == CJJTimerViewMode_HM){
            if([self NullStr:_minColonL.text]){
                make.right.mas_equalTo(_minColonL.mas_left);
            }else{
                make.right.mas_equalTo(_minColonL.mas_left).offset(-self.configuration.timerViewHorizontalInset);
            }
        }else{
            make.right.mas_equalTo(_minColonL.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }
        make.centerY.mas_equalTo(_secColonL);
        make.width.mas_equalTo(self.configuration.timerViewWidth);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];
    
    [_hourColonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secColonL);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
        if(self.configuration.mode == CJJTimerViewMode_MS){
            make.right.mas_equalTo(_minV.mas_left);
            make.width.mas_equalTo(0);
        }else{
            make.right.mas_equalTo(_minV.mas_left).offset(-self.configuration.timerViewHorizontalInset);
            make.width.mas_equalTo(self.configuration.timerColonWidth);
        }
    }];
    
    [_hourV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_secColonL);
        if(self.configuration.mode == CJJTimerViewMode_MS){
            make.width.mas_equalTo(0);
            make.right.mas_equalTo(_hourColonL.mas_left);
        }else{
            make.width.mas_equalTo(self.configuration.timerViewWidth);
            make.right.mas_equalTo(_hourColonL.mas_left).offset(-self.configuration.timerViewHorizontalInset);
        }
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];

    [_hourL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [_minL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [_secL mas_makeConstraints:^(MASConstraintMaker *make) {
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
            [self.hourV mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_MS){
                    make.width.mas_equalTo(0);
                }else{
                    make.width.mas_equalTo(self.configuration.timerViewWidth);
                }
            }];
            
            [self.minV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.configuration.timerViewWidth);
            }];
            
            [self.secV mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_HM){
                    make.width.mas_equalTo(0);
                }else{
                    make.width.mas_equalTo(self.configuration.timerViewWidth);
                }
            }];
        }else if ([keyPath isEqualToString:@"timerViewHeight"]){
            [self.hourV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.configuration.timerViewHeight);
            }];
            
            [self.minV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.configuration.timerViewHeight);
            }];
            
            [self.secV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.configuration.timerViewHeight);
            }];
        }else if ([keyPath isEqualToString:@"timerColonWidth"]){
            [_hourColonL mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_MS){
                    make.width.mas_equalTo(0);
                }else{
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }
            }];
            
            [_minColonL mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.mode == CJJTimerViewMode_HM){
                    if([self NullStr:_minColonL.text]){
                        make.width.mas_equalTo(0);
                    }else{
                        make.width.mas_equalTo(self.configuration.timerColonWidth);
                    }
                }else{
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }
            }];
            
            [_secColonL mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.isExistRightExtraView){
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }else{
                    make.width.mas_equalTo(0);
                }
            }];
        }else if ([keyPath isEqualToString:@"timerViewBackgroundColor"]){
            self.hourV.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
            self.minV.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
            self.secV.layer.backgroundColor = self.configuration.timerViewBackgroundColor.CGColor;
        }else if ([keyPath isEqualToString:@"timerViewCornerRadius"]){
            self.hourV.layer.cornerRadius = self.configuration.timerViewCornerRadius;
            self.minV.layer.cornerRadius = self.configuration.timerViewCornerRadius;
            self.secV.layer.cornerRadius = self.configuration.timerViewCornerRadius;
        }else if ([keyPath isEqualToString:@"timerViewShadowColor"]){
            self.hourV.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
            self.minV.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
            self.secV.layer.shadowColor = self.configuration.timerViewShadowColor.CGColor;
        }else if ([keyPath isEqualToString:@"timerViewShadowOffset"]){
            self.hourV.layer.shadowOffset = self.configuration.timerViewShadowOffset;
            self.minV.layer.shadowOffset = self.configuration.timerViewShadowOffset;
            self.secV.layer.shadowOffset = self.configuration.timerViewShadowOffset;
        }else if ([keyPath isEqualToString:@"timerViewShadowOpacity"]){
            self.hourV.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
            self.minV.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
            self.secV.layer.shadowOpacity = self.configuration.timerViewShadowOpacity;
        }else if ([keyPath isEqualToString:@"timerViewShadowRadius"]){
            self.hourV.layer.shadowRadius = self.configuration.timerViewShadowRadius;
            self.minV.layer.shadowRadius = self.configuration.timerViewShadowRadius;
            self.secV.layer.shadowRadius = self.configuration.timerViewShadowRadius;
        }else if ([keyPath isEqualToString:@"timerTextLabelColor"]){
            self.hourL.textColor = self.configuration.timerTextLabelColor;
            self.minL.textColor = self.configuration.timerTextLabelColor;
            self.secL.textColor = self.configuration.timerTextLabelColor;
        }else if ([keyPath isEqualToString:@"timerColonLabelColor"]){
            self.hourColonL.textColor = self.configuration.timerColonLabelColor;
            self.minColonL.textColor = self.configuration.timerColonLabelColor;
        }else if ([keyPath isEqualToString:@"timerTextLabelFont"]){
            self.hourL.font = self.configuration.timerTextLabelFont;
            self.minL.font = self.configuration.timerTextLabelFont;
            self.secL.font = self.configuration.timerTextLabelFont;
        }else if ([keyPath isEqualToString:@"timerColonLabelFont"]){
            self.hourColonL.font = self.configuration.timerColonLabelFont;
            self.minColonL.font = self.configuration.timerColonLabelFont;
            self.secColonL.font = self.configuration.timerColonLabelFont;
        }else if ([keyPath isEqualToString:@"timerColonHourLabelText"]){
            self.hourColonL.text = self.configuration.timerColonHourLabelText;
        }else if ([keyPath isEqualToString:@"timerColonMinLabelText"]){
            self.minColonL.text = self.configuration.timerColonMinLabelText;
        }else if ([keyPath isEqualToString:@"timerColonSecLabelText"]){
            self.secColonL.text = self.configuration.timerColonSecLabelText;
            [_secColonL mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.isExistRightExtraView){
                    make.width.mas_equalTo(self.configuration.timerColonWidth);
                }else{
                    make.width.mas_equalTo(0);
                }
            }];
            
            [_secV mas_updateConstraints:^(MASConstraintMaker *make) {
                if(self.configuration.isExistRightExtraView){
                    make.right.mas_equalTo(_secColonL.mas_left).offset(-self.configuration.timerViewHorizontalInset);
                }else{
                    make.right.mas_equalTo(_secColonL.mas_left).offset(0);
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
    _hourL.text = @"00";
    _minL.text = @"00";
    _secL.text = @"00";
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
    
    NSInteger lastHour = compareDate.hour+compareDate.day*24;
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
        self.hourL.text = [NSString stringWithFormat:@"0%ld",(long)lastHour];
    }else{
        self.hourL.text = [NSString stringWithFormat:@"%ld",(long)lastHour];
    }
    
    if(lastMinute < 10){
        self.minL.text = [NSString stringWithFormat:@"0%ld",(long)lastMinute];
    }else{
        self.minL.text = [NSString stringWithFormat:@"%ld",(long)lastMinute];
    }
    
    if(lastSecond < 10){
        self.secL.text = [NSString stringWithFormat:@"0%ld",(long)lastSecond];
    }else{
        self.secL.text = [NSString stringWithFormat:@"%ld",(long)lastSecond];
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
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
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
    if(self.hourL.text.floatValue >= 100){
        CGFloat oneLineH = [self getLabelHeightWithString:@"one" Width:20 font:self.configuration.timerTextLabelFont];
        CGFloat hourW = [self getLabelWidthWithString:self.hourL.text Height:oneLineH font:self.configuration.timerTextLabelFont]+5;
        
        if(self.hourLastWidth > 0){
            if(self.hourLastWidth != hourW){
                if(self.configuration.mode == CJJTimerViewMode_MS){
                    hourW = 0;
                }
                self.hourLastWidth = hourW;
                [_hourV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(hourW);
                }];
            }
        }else{
            if(self.configuration.mode == CJJTimerViewMode_MS){
                hourW = 0;
            }
            self.hourLastWidth = hourW;
            [_hourV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(hourW);
            }];
        }
    }else{
        if(self.configuration.mode == CJJTimerViewMode_MS){
            self.hourLastWidth = 0;
        }else{
            self.hourLastWidth = self.configuration.timerViewWidth;
        }
        [_hourV mas_updateConstraints:^(MASConstraintMaker *make) {
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

- (void)setHourLastWidth:(CGFloat)hourLastWidth{
    _hourLastWidth = hourLastWidth;
    if(_hourLastWidth > self.configuration.timerViewWidth){
        if(self.hourOriginWidth == 0){
            self.hourOriginWidth = self.configuration.timerWidth;
        }
        [self.configuration setValue:@(self.hourOriginWidth + (_hourLastWidth - self.configuration.timerViewWidth)) forKey:@"timerWidth"];
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

- (UIView *)hourV{
    if(!_hourV){
        _hourV = [UIView new];
    }
    return _hourV;
}

- (UIView *)minV{
    if(!_minV){
        _minV = [UIView new];
    }
    return _minV;
}

- (UIView *)secV{
    if(!_secV){
        _secV = [UIView new];
    }
    return _secV;
}

- (UILabel *)hourL{
    if(!_hourL){
        _hourL = [UILabel new];
        _hourL.text = @"00";
        _hourL.textAlignment = NSTextAlignmentCenter;
    }
    return _hourL;
}

- (UILabel *)minL{
    if(!_minL){
        _minL = [UILabel new];
        _minL.text = @"00";
        _minL.textAlignment = NSTextAlignmentCenter;
    }
    return _minL;
}

- (UILabel *)secL{
    if(!_secL){
        _secL = [UILabel new];
        _secL.text = @"00";
        _secL.textAlignment = NSTextAlignmentCenter;
    }
    return _secL;
}

- (UILabel *)hourColonL{
    if(!_hourColonL){
        _hourColonL = [UILabel new];
        _hourColonL.textAlignment = NSTextAlignmentCenter;
    }
    return _hourColonL;
}

- (UILabel *)minColonL{
    if(!_minColonL){
        _minColonL = [UILabel new];
        _minColonL.textAlignment = NSTextAlignmentCenter;
    }
    return _minColonL;
}

- (UILabel *)secColonL{
    if(!_secColonL){
        _secColonL = [UILabel new];
        _secColonL.textAlignment = NSTextAlignmentCenter;
    }
    return _secColonL;
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


