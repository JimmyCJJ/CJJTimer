//
//  CJJTimer.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/21.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimer.h"

typedef NS_ENUM(NSInteger,CJJTimerViewType){
    CJJTimerView_TimerView = 1,
    CJJTimerView_TextLabel,
    CJJTimerView_ColonLabel
};

@interface CJJTimerConfiguration ()
/// 自动计算timer的宽度
@property (nonatomic, assign, readwrite) CGFloat timerWidth;
/// 自动计算timer的高度
@property (nonatomic, assign, readwrite) CGFloat timerHeight;
@end

@implementation CJJTimerConfiguration

+ (instancetype)configureTimer{
    CJJTimerConfiguration *configuration = [[CJJTimerConfiguration alloc] init];
    return configuration;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureData];
    }
    return self;
}

- (void)configureData{
    self.timerLastTime = @"";
    self.timerViewWidth = 22;
    self.timerViewHeight = 22;
    self.timerViewInset = 4;
    self.timerColonWidth = 4;
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
}

- (void)setTimerViewWidth:(CGFloat)timerViewWidth{
    _timerViewWidth = timerViewWidth;
    [self caculateSize];
}

- (void)setTimerViewHeight:(CGFloat)timerViewHeight{
    _timerViewHeight = timerViewHeight;
    [self caculateSize];
}

- (void)setTimerViewInset:(CGFloat)timerViewInset{
    _timerViewInset = timerViewInset;
    [self caculateSize];
}

- (void)setTimerColonWidth:(CGFloat)timerColonWidth{
    _timerColonWidth = timerColonWidth;
    [self caculateSize];
}

- (void)caculateSize{
    self.timerWidth = self.timerViewWidth * 3 + 4*self.timerViewInset + 2*self.timerColonWidth;
    self.timerHeight = self.timerViewHeight;
}

@end

@interface CJJTimer ()
@property (nonatomic, strong) UIView *hourV;
@property (nonatomic, strong) UIView *minV;
@property (nonatomic, strong) UIView *secV;
@property (nonatomic, copy) UILabel *hourL;
@property (nonatomic, copy) UILabel *minL;
@property (nonatomic, copy) UILabel *secL;
@property (nonatomic, strong) UILabel *firstColonL;
@property (nonatomic, strong) UILabel *secondColonL;

@property (nonatomic, assign) CGFloat hourLastWidth;
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@end

@implementation CJJTimer

+ (instancetype)timerWithConfigure:(CJJTimerConfiguration *)configuration{
    CJJTimer *timer = [[CJJTimer alloc] initWithFrame:CGRectZero];
    timer.configuration = configuration;
    [timer setViews];
    [timer setLayout];
    return timer;
}

- (void)configureLayout:(CJJTimerLayout)layout{
    layout(self.configuration.timerWidth, self.configuration.timerHeight);
    layout = nil;
}

- (void)setViews{
    [self addSubview:self.hourV];
    [self addSubview:self.minV];
    [self addSubview:self.secV];
    [self.hourV addSubview:self.hourL];
    [self.minV addSubview:self.minL];
    [self.secV addSubview:self.secL];
    [self addSubview:self.firstColonL];
    [self addSubview:self.secondColonL];
    
    [self displayViews:self.hourV viewType:CJJTimerView_TimerView];
    [self displayViews:self.minV viewType:CJJTimerView_TimerView];
    [self displayViews:self.secV viewType:CJJTimerView_TimerView];
    [self displayViews:self.hourL viewType:CJJTimerView_TextLabel];
    [self displayViews:self.minL viewType:CJJTimerView_TextLabel];
    [self displayViews:self.secL viewType:CJJTimerView_TextLabel];
    [self displayViews:self.firstColonL viewType:CJJTimerView_ColonLabel];
    [self displayViews:self.secondColonL viewType:CJJTimerView_ColonLabel];
    
}

- (void)setLayout{
    
    [_minV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.configuration.timerViewWidth);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];
    
    [_firstColonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_minV);
        make.right.mas_equalTo(_minV.mas_left).offset(-self.configuration.timerViewInset);
        make.width.mas_equalTo(self.configuration.timerColonWidth);
    }];
    
    [_hourV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_minV);
        make.right.mas_equalTo(_firstColonL.mas_left).offset(-self.configuration.timerViewInset);
        make.width.mas_equalTo(self.configuration.timerViewWidth);
        make.height.mas_equalTo(self.configuration.timerViewHeight);
    }];
    
    [_secondColonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_minV);
        make.left.mas_equalTo(_minV.mas_right).offset(self.configuration.timerViewInset);
        make.width.mas_equalTo(self.configuration.timerColonWidth);
    }];
    
    [_secV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_minV);
        make.left.mas_equalTo(_secondColonL.mas_right).offset(self.configuration.timerViewInset);
        make.width.mas_equalTo(self.configuration.timerViewWidth);
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

- (void)displayViews:(UIView *)view viewType:(CJJTimerViewType)viewType{
    CJJTimerConfiguration *configuration = self.configuration;
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
        }
            break;
    }
}

#pragma mark - logic

/// 开启倒计时
- (void)beginTimer{
    [self endTimer];
    //先赋值一次
    [self refreshView];
    [self refreshLayout];
    //GCD定时器
    self.dispatchTimer = CreateDispatchTimer(1.0*NSEC_PER_SEC, 0, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshView];
        });
    });
}

dispatch_source_t CreateDispatchTimer(uint64_t interval,
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

/// 停止倒计时
- (void)endTimer{
    if(self.dispatchTimer){
        dispatch_source_cancel(self.dispatchTimer);
        self.dispatchTimer = nil;
    }
}

- (void)refreshView{
    
    //获取当前时间戳
    NSString *currentStamp = [self getNowTimeTimeStampSec];
    NSString *endStamp = self.configuration.timerLastTime;
    
    NSDateComponents *compareDate = [self startTimeStamp:currentStamp endTimeStamp:endStamp];
    
    NSInteger lastHour = compareDate.hour+compareDate.day*24;
    NSInteger lastMinute = compareDate.minute;
    NSInteger lastSecond = compareDate.second;
    if(lastHour < 10){
        self.hourL.text = [NSString stringWithFormat:@"0%ld",lastHour];
    }else{
        self.hourL.text = [NSString stringWithFormat:@"%ld",lastHour];
    }
    
    if(lastMinute < 10){
        self.minL.text = [NSString stringWithFormat:@"0%ld",lastMinute];
    }else{
        self.minL.text = [NSString stringWithFormat:@"%ld",lastMinute];
    }
    
    if(lastSecond < 10){
        self.secL.text = [NSString stringWithFormat:@"0%ld",lastSecond];
    }else{
        self.secL.text = [NSString stringWithFormat:@"%ld",lastSecond];
    }
    
    [self refreshLayout];
    
    
    
//    if((23-dateComponents.hour) < 10){
//        self.hourL.text = [NSString stringWithFormat:@"0%ld",23-dateComponents.hour];
//    }else{
//        self.hourL.text = [NSString stringWithFormat:@"%ld",23-dateComponents.hour];
//    }
//
//    if((59-dateComponents.minute) < 10){
//        self.minL.text = [NSString stringWithFormat:@"0%ld",59-dateComponents.minute];
//    }else{
//        self.minL.text = [NSString stringWithFormat:@"%ld",59-dateComponents.minute];
//    }
//
//    if((59-dateComponents.second) < 10){
//        self.secL.text = [NSString stringWithFormat:@"0%ld",59-dateComponents.second];
//    }else{
//        self.secL.text = [NSString stringWithFormat:@"%ld",59-dateComponents.second];
//    }
    
}

#pragma mark  比较takeCarTime与systemTime

- (NSDateComponents *)startTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp
{
    //  时区相差8个小时 加上这个时区即是北京时间
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger delta = [timeZone secondsFromGMT];
    // 两个时间戳转换日期类
    
    NSDate *DRstartDate = [[NSDate alloc] initWithTimeIntervalSince1970:[startTimeStamp doubleValue] + delta];
    NSDate *DRendDate = [[NSDate alloc] initWithTimeIntervalSince1970:[endTimeStamp doubleValue] + delta];
    // 日历对象 （方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit 枚举代表想获得哪些差值 NSCalendarUnitYear 年 NSCalendarUnitWeekOfMonth 月
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:DRstartDate toDate:DRendDate options:0];
    // 获得某个时间的年月日时分秒
    
    //        NSDateComponents *createDateCmps = [calendar components:unit fromDate:DRstartDate];
    
    //        NSDateComponents *nowCmps = [calendar components:unit fromDate:DRendDate];
//    NSLog(@"剩余%ld天,%ld小时%ld分%ld秒", cmps.day ,cmps.hour, cmps.minute, cmps.second);
//    NSLog(@"相差%ld小时",cmps.hour);
    return cmps;
}

////返回秒为单位的时间戳
- (NSString *)getNowTimeTimeStampSec{

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;

}

//返回毫秒为单位的时间戳
- (NSString *)getNowTimeTimestampMinSec{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    
    return timeSp;
}

#pragma mark - refersh layout

- (void)refreshLayout{
    CGFloat oneLineH = [self getLabelHeightWithString:@"one" Width:20 font:self.configuration.timerTextLabelFont];
    CGFloat hourW = [self getLabelWidthWithString:self.hourL.text Height:oneLineH font:self.configuration.timerTextLabelFont]+2;
    
    if(self.hourLastWidth > 0){
        if(self.hourLastWidth != hourW){
            self.hourLastWidth = hourW;
            [_hourV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(hourW);
            }];
        }
    }else{
        self.hourLastWidth = hourW;
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

#pragma mark - lazy

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

- (UILabel *)firstColonL{
    if(!_firstColonL){
        _firstColonL = [UILabel new];
        _firstColonL.text = @":";
        _firstColonL.textAlignment = NSTextAlignmentCenter;
    }
    return _firstColonL;
}

- (UILabel *)secondColonL{
    if(!_secondColonL){
        _secondColonL = [UILabel new];
        _secondColonL.text = @":";
        _secondColonL.textAlignment = NSTextAlignmentCenter;
    }
    return _secondColonL;
}

#pragma mark - deadline

- (void)dealloc
{
    [self endTimer];
}

@end

