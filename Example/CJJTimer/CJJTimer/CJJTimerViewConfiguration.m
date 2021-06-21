//
//  CJJTimerViewConfiguration.m
//  CJJTimer
//
//  Created by JimmyCJJ on 2020/8/18.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerViewConfiguration.h"
#import "CJJTimerTool.h"
#import "CJJTimer.h"

@interface CJJTimerViewConfiguration ()
/// 自动计算timer的宽度
@property (nonatomic, assign, readwrite) CGFloat timerWidth;
/// 自动计算timer的高度
@property (nonatomic, assign, readwrite) CGFloat timerHeight;

@property (nonatomic, assign, readwrite) CJJTimerViewMode mode;
@end

@implementation CJJTimerViewConfiguration

+ (instancetype)configureTimerView {
    return [self configureTimerViewWithMode:CJJTimerViewMode_HMS];
}

+ (instancetype)configureTimerViewWithMode:(CJJTimerViewMode)mode {
    CJJTimerViewConfiguration *configuration = [[CJJTimerViewConfiguration alloc] initWithMode:mode];
    return configuration;
}

- (instancetype)init
{
    return [self initWithMode:CJJTimerViewMode_HMS];
}

- (instancetype)initWithMode:(CJJTimerViewMode)mode
{
    self = [super init];
    if (self) {
        self.mode = mode;
        [self configureData];
    }
    return self;
}

- (void)configureData {
    //UI Config
    self.timerLastTime = @"";
    self.timerAutoStart = YES;
    self.timerHiddenWhenFinished = YES;
    self.timerAutoChangeMode = NO;
    self.timerViewBackgroundColor = [UIColor whiteColor];
    self.timerViewCornerRadius = 0;
    self.timerViewShadowColor = nil;
    self.timerViewShadowOffset = CGSizeZero;
    self.timerViewShadowOpacity = 0;
    self.timerViewShadowRadius = 0;
    self.timerTextLabelColor = [UIColor blackColor];
    self.timerColonLabelColor = [UIColor blackColor];
    self.timerTextLabelFont = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    self.timerColonLabelFont = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    
    if (self.mode == CJJTimerViewMode_DHMS) {
        self.timerColonDayLabelText = @"天";
        self.timerColonHourLabelText = @":";
        self.timerColonMinLabelText = @":";
        self.timerColonSecLabelText = @"";
    } else if (self.mode == CJJTimerViewMode_HMS) {
        self.timerColonDayLabelText = @"";
        self.timerColonHourLabelText = @":";
        self.timerColonMinLabelText = @":";
        self.timerColonSecLabelText = @"";
    } else if (self.mode == CJJTimerViewMode_HM) {
        self.timerColonDayLabelText = @"";
        self.timerColonHourLabelText = @":";
        self.timerColonMinLabelText = @"";
        self.timerColonSecLabelText = @"";
    } else if (self.mode == CJJTimerViewMode_MS) {
        self.timerColonDayLabelText = @"";
        self.timerColonHourLabelText = @"";
        self.timerColonMinLabelText = @":";
        self.timerColonSecLabelText = @"";
    }
    
    //Layout Config
    self.timerViewWidth = 24;
    self.timerViewHeight = 24;
    self.timerColonWidth = 10;
    self.timerDayColonWidth = 16;
    self.timerHourColonWidth = 10;
    self.timerMinColonWidth = 10;
    self.timerSecColonWidth = 0;
    self.timerInsets = UIEdgeInsetsZero;
}

- (void)changeMode:(CJJTimerViewMode)mode {
    if ([self.datasource isKindOfClass:[CJJTimerView class]]) {
        self.mode = mode;
        CJJTimerView *timerView = (CJJTimerView *)self.datasource;
        if ([timerView.delegate respondsToSelector:@selector(changeModeInTimerView:)]) {
            [timerView.delegate changeModeInTimerView:timerView];
        }
    }
}

- (void)setTimerViewWidth:(CGFloat)timerViewWidth {
    _timerViewWidth = timerViewWidth;
    [self caculateSize];
}

- (void)setTimerViewHeight:(CGFloat)timerViewHeight {
    _timerViewHeight = timerViewHeight;
    [self caculateSize];
}

- (void)setTimerColonWidth:(CGFloat)timerColonWidth {
    _timerColonWidth = timerColonWidth;
    _timerDayColonWidth = timerColonWidth;
    _timerHourColonWidth = timerColonWidth;
    _timerMinColonWidth = timerColonWidth;
    _timerSecColonWidth = timerColonWidth;
    [self caculateSize];
}

- (void)setTimerDayColonWidth:(CGFloat)timerDayColonWidth {
    _timerDayColonWidth = timerDayColonWidth;
    [self caculateSize];
}

- (void)setTimerHourColonWidth:(CGFloat)timerHourColonWidth {
    _timerHourColonWidth = timerHourColonWidth;
    [self caculateSize];
}

- (void)setTimerMinColonWidth:(CGFloat)timerMinColonWidth {
    _timerMinColonWidth = timerMinColonWidth;
    [self caculateSize];
}

- (void)setTimerSecColonWidth:(CGFloat)timerSecColonWidth {
    _timerSecColonWidth = timerSecColonWidth;
    [self caculateSize];
}

- (void)setTimerInsets:(UIEdgeInsets)timerInsets {
    _timerInsets = timerInsets;
    [self caculateSize];
}

- (void)setTimerColonSecLabelText:(NSString *)timerColonSecLabelText {
    _timerColonSecLabelText = timerColonSecLabelText;
    [self caculateSize];
}

- (void)caculateSize {
    self.timerWidth = [self.datasource respondsToSelector:@selector(timerViewWidthInConfiguration:)] ? [self.datasource timerViewWidthInConfiguration:self] : 0;
    self.timerHeight = self.timerViewHeight+self.timerInsets.top+self.timerInsets.bottom;
    
}

@end
