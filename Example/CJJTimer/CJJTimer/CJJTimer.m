//
//  CJJTimer.m
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
//弱化
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
//代码块里面强化，防止丢失
#define kStrongSelf(type) __strong typeof(type) strong##type = weak##type;

#import "CJJTimer.h"
#import "Masonry.h"

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
    self.timerAutoStart = YES;
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

#pragma mark -

static NSArray * CJJTimerObserverKeyPaths() {
    static NSArray *_CJJTimerObservedKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _CJJTimerObservedKeyPaths = @[@"timerLastTime"];
    });
    return _CJJTimerObservedKeyPaths;
}

static void *CJJTimerObserverContext = &CJJTimerObserverContext;

@interface CJJTimer ()
@property (nonatomic, strong) UIView *hourV;
@property (nonatomic, strong) UIView *minV;
@property (nonatomic, strong) UIView *secV;
@property (nonatomic, strong) UILabel *hourL;
@property (nonatomic, strong) UILabel *minL;
@property (nonatomic, strong) UILabel *secL;
@property (nonatomic, strong) UILabel *firstColonL;
@property (nonatomic, strong) UILabel *secondColonL;

@property (nonatomic, assign) CGFloat hourLastWidth;
@property (nonatomic, assign, getter=isSubspend) BOOL subspend;
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@end

@implementation CJJTimer

+ (instancetype)timerWithConfiguration:(CJJTimerConfiguration *)configuration{
    CJJTimer *timer = [[CJJTimer alloc] initWithFrame:CGRectZero];
    timer.configuration = configuration;
    [timer setUp];
    return timer;
}

- (void)setUp{
    [self setObserveValue];
    [self setViews];
    [self setLayout];
    if(self.configuration.isTimerAutoStart){
        [self startTimer];
    }
}

- (void)setObserveValue{
    for (NSString *keyPath in CJJTimerObserverKeyPaths()) {
        if([self.configuration respondsToSelector:NSSelectorFromString(keyPath)]){
            [self.configuration addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:CJJTimerObserverContext];
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

- (void)configureLayout:(CJJTimerLayout)layout{
    layout(self.configuration.timerWidth, self.configuration.timerHeight);
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CJJTimerObserverContext) {
        if([keyPath isEqualToString:@"timerLastTime"]){
            [self startTimer];
        }
    }
}

#pragma mark - logic

/// 开启定时器
- (dispatch_source_t)startTimer{
    //先赋值一次
    [self refreshView];
    [self refreshLayout];
    //GCD定时器
    return self.dispatchTimer;
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
}

/// 暂停定时器
- (void)suspendTimer{
    if(_dispatchTimer){
        dispatch_suspend(_dispatchTimer);
        self.subspend = YES;
    }
}

/// 恢复定时器
- (void)resumeTimer{
    if(_dispatchTimer){
        dispatch_resume(_dispatchTimer);
        _subspend = NO;
    }
}

/// 重置定时器
- (void)resetTimer{
    
}

#pragma mark - refresh UI

- (void)refreshView{
    
    //获取当前时间戳
    NSString *currentStamp = [self getNowTimeTimeStampSec];
    NSString *endStamp = self.configuration.timerLastTime;
    
    NSDateComponents *compareDate = [self startTimeStamp:currentStamp endTimeStamp:endStamp];
    
    NSInteger lastHour = compareDate.hour+compareDate.day*24;
    NSInteger lastMinute = compareDate.minute;
    NSInteger lastSecond = compareDate.second;
    
    if(lastHour <= 0 && lastMinute <= 0 && lastSecond <= 0){
        self.hourL.text = @"00";
        self.minL.text = @"00";
        self.secL.text = @"00";
        [self stopTimer];
        return;
    }
    
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
    CGFloat oneLineH = [self getLabelHeightWithString:@"one" Width:20 font:self.configuration.timerTextLabelFont];
    CGFloat hourW = [self getLabelWidthWithString:self.hourL.text Height:oneLineH font:self.configuration.timerTextLabelFont]+5;
    
    if(self.hourLastWidth > 0){
        if(self.hourLastWidth != hourW){
            self.hourLastWidth = hourW;
            [_hourV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(hourW);
            }];
        }
    }else{
        self.hourLastWidth = hourW;
        [_hourV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(hourW);
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

#pragma mark - lazy

- (dispatch_source_t)dispatchTimer{
    if(!_dispatchTimer){
        kWeakSelf(self)
        _dispatchTimer = CreateDispatchTimer(1.0*NSEC_PER_SEC, 0, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                kStrongSelf(self)
                [strongself refreshView];
            });
        });
    }
    return _dispatchTimer;
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
    NSLog(@"CJJ定时器销毁");
    [self stopTimer];
    for (NSString *keyPath in CJJTimerObserverKeyPaths()) {
        if([self.configuration respondsToSelector:NSSelectorFromString(keyPath)]){
            [self.configuration removeObserver:self forKeyPath:keyPath context:CJJTimerObserverContext];
        }
    }
}

@end

