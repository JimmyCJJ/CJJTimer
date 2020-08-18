//
//  CJJTimerViewConfiguration.m
//  CJJTimer
//
//  Created by wangfeng on 2020/8/18.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerViewConfiguration.h"

@interface CJJTimerViewConfiguration ()
/// 自动计算timer的宽度
@property (nonatomic, assign, readwrite) CGFloat timerWidth;
/// 自动计算timer的高度
@property (nonatomic, assign, readwrite) CGFloat timerHeight;

@property (nonatomic, assign, readwrite) CJJTimerViewMode mode;
/// 是否存在最右边的额外view（例,00时00分00秒的秒,默认为NO）
@property (nonatomic, assign, getter=isExistRightExtraView, readwrite) BOOL existRightExtraView;
@end

@implementation CJJTimerViewConfiguration

+ (instancetype)configureTimerView{
    return [self configureTimerViewWithMode:CJJTimerViewMode_HMS];
}

+ (instancetype)configureTimerViewWithMode:(CJJTimerViewMode)mode{
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

- (void)configureData{
    //UI Config
    self.timerLastTime = @"";
    self.timerAutoStart = YES;
    self.timerHiddenWhenFinished = YES;
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
    
    if(self.mode == CJJTimerViewMode_MS){
        self.timerColonHourLabelText = @"";
    }else{
        self.timerColonHourLabelText = @":";
    }
    
    if(self.mode == CJJTimerViewMode_HM){
        self.timerColonMinLabelText = @"";
    }else{
        self.timerColonMinLabelText = @":";
    }
    
    self.timerColonSecLabelText = @"";
    //Layout Config
    self.timerViewWidth = 22;
    self.timerViewHeight = 22;
    self.timerViewHorizontalInset = 4;
    self.timerColonWidth = 4;
    self.timerInsets = UIEdgeInsetsZero;
    self.existRightExtraView = NO;
}

- (void)setTimerViewWidth:(CGFloat)timerViewWidth{
    _timerViewWidth = timerViewWidth;
    [self caculateSize];
}

- (void)setTimerViewHeight:(CGFloat)timerViewHeight{
    _timerViewHeight = timerViewHeight;
    [self caculateSize];
}

- (void)setTimerViewHorizontalInset:(CGFloat)timerViewHorizontalInset{
    _timerViewHorizontalInset = timerViewHorizontalInset;
    [self caculateSize];
}

- (void)setTimerColonWidth:(CGFloat)timerColonWidth{
    _timerColonWidth = timerColonWidth;
    [self caculateSize];
}

- (void)setTimerInsets:(UIEdgeInsets)timerInsets{
    _timerInsets = timerInsets;
    [self caculateSize];
}

- (void)setExistRightExtraView:(BOOL)existRightExtraView{
    if(self.mode == CJJTimerViewMode_HM){
        _existRightExtraView = NO;
    }else{
        _existRightExtraView = existRightExtraView;
    }
}

- (void)setTimerColonSecLabelText:(NSString *)timerColonSecLabelText{
    _timerColonSecLabelText = timerColonSecLabelText;
    if([self NullStr:_timerColonSecLabelText]){
        self.existRightExtraView = NO;
    }else{
        self.existRightExtraView = YES;
    }
    [self caculateSize];
}

- (void)caculateSize{
    //最右边的额外view
    CGFloat extraCount = 0;
    if(self.existRightExtraView){
        extraCount = 1;
    }
    
    CGFloat reduceWidth = 0;
    switch (self.mode) {
        case CJJTimerViewMode_HMS:
            //00-:-00-:-00 / 00-时-00-分-00-秒
            break;
        case CJJTimerViewMode_HM://30+4+30+4+30+4+30  30+4+30+4+30
            //00-:-00 / 00-时-00-分
            if([self NullStr:self.timerColonMinLabelText]){
                reduceWidth = self.timerViewHorizontalInset*2+self.timerViewWidth*1+self.timerColonWidth*1;
            }else{
                reduceWidth = self.timerViewHorizontalInset*1+self.timerViewWidth*1;
            }
            break;
        case CJJTimerViewMode_MS:
            //00-:-00 / 00-分-00-秒
            reduceWidth = self.timerViewHorizontalInset*2+self.timerViewWidth*1+self.timerColonWidth*1;
            break;
    }
    
    self.timerWidth = self.timerViewWidth*3 + self.timerViewHorizontalInset*(4+extraCount) + self.timerColonWidth*(2+extraCount)+self.timerInsets.left+self.timerInsets.right - reduceWidth;
    self.timerHeight = self.timerViewHeight+self.timerInsets.top+self.timerInsets.bottom;
}

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

@end
