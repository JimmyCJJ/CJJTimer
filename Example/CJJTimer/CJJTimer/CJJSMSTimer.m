//
//  CJJSMSTimer.m
//  CJJTimer
//
//  Created by JimmyCJJ on 2020/2/20.
//  Copyright © 2020 CJJTimer. All rights reserved.
//

#import "CJJSMSTimer.h"
#import "CJJTimerMacro.h"
@interface CJJSMSTimer()
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@property (nonatomic, assign, getter=isCustom) BOOL custom;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, copy) NSString *finishedTitle;
@property (nonatomic, strong) UIColor *finishedTitleColor;
@property (nonatomic, copy) NSString *ingTitle;
@property (nonatomic, strong) UIColor *ingTitleColor;
@property (nullable, nonatomic, copy) CJJSMSTimerVoidBlock finishedBlock;
@property (nullable, nonatomic, copy) CJJSMSTimerSecBlock ingBlock;
@end
@implementation CJJSMSTimer

/** 开启倒计时 - 完全自定义回调 */
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                    titleIngSettingBlock:(CJJSMSTimerSecBlock __nullable)ingBlock
                  titleFinishSettingBlock:(CJJSMSTimerVoidBlock __nullable)finishedBlock{
    return [self timerStartCountdownWithCustom:YES btn:btn timeOut:timeOut ingTitle:nil ingTitleColor:nil finishedTitle:nil finishedTitleColor:nil titleIngSettingBlock:ingBlock titleFinishSettingBlock:finishedBlock];
}

/** 开启倒计时 - 默认回调 */
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                               ingTitle:(NSString *)ingTitle
                           ingTitleColor:(UIColor *)ingTitleColor
                           finishedTitle:(NSString *)finishedTitle
                       finishedTitleColor:(UIColor *)finishedTitleColor
                      titleIngSettingBlock:(CJJSMSTimerSecBlock __nullable)ingBlock
                    titleFinishSettingBlock:(CJJSMSTimerVoidBlock __nullable)finishedBlock{
    return [self timerStartCountdownWithCustom:NO btn:btn timeOut:timeOut ingTitle:ingTitle ingTitleColor:ingTitleColor finishedTitle:finishedTitle finishedTitleColor:finishedTitleColor titleIngSettingBlock:ingBlock titleFinishSettingBlock:finishedBlock];
}

/** 开启倒计时 - inner */
+ (instancetype)timerStartCountdownWithCustom:(BOOL)custom
                                     btn:(UIButton *)btn
                                  timeOut:(int)timeOut
                                  ingTitle:(NSString * __nullable)ingTitle
                              ingTitleColor:(UIColor * __nullable)ingTitleColor
                              finishedTitle:(NSString * __nullable)finishedTitle
                          finishedTitleColor:(UIColor * __nullable)finishedTitleColor
                         titleIngSettingBlock:(CJJSMSTimerSecBlock __nullable)ingBlock
                       titleFinishSettingBlock:(CJJSMSTimerVoidBlock __nullable)finishedBlock{
    if(![btn isKindOfClass:[UIButton class]]){
        NSAssert([btn isKindOfClass:[UIButton class]], @"btn must an instance of UIButton");
    }
    NSAssert(timeOut > 0, @"timeOut must be greater than zero");
    CJJSMSTimer *timer = [[CJJSMSTimer alloc] init];
    timer.custom = custom;
    timer.btn = btn;
    timer.timeOut = timeOut;
    timer.ingTitle = ingTitle;
    timer.ingTitleColor = ingTitleColor;
    timer.finishedTitle = finishedTitle;
    timer.finishedTitleColor = finishedTitleColor;
    timer.ingBlock = ingBlock;
    timer.finishedBlock = finishedBlock;
    [timer startTimer];
    return timer;
}

- (dispatch_source_t)startTimer{
                  
    NSAssert(self.timeOut > 0, @"timeOut must be greater than 0!");
    
    return self.dispatchTimer;
}

- (void)handleEvent{
    if(self.timeOut <= 0){
        //倒计时结束
        //关闭定时器
        dispatch_source_cancel(self.dispatchTimer);
        dispatch_async(dispatch_get_main_queue(), ^{
            //倒计时结束的按钮显示 根据自己需求在block里设置
            self.btn.enabled=YES;
            if(!self.custom){
                [self.btn setTitle:self.finishedTitle forState:UIControlStateNormal];
                [self.btn setTitleColor:self.finishedTitleColor forState:UIControlStateNormal];
            }
            if(self.finishedBlock){
                self.finishedBlock();
            }
        });
    }else{
        //倒计时中
        //显示倒计时结果
        dispatch_async(dispatch_get_main_queue(), ^{
            //倒计时中的按钮显示 根据自己需求在block里设置
            self.btn.enabled = NO;
            if(!self.custom){
                if(self.ingTitle.length > 0){
                    [self.btn setTitle:[NSString stringWithFormat:@"%@(%ds)",self.ingTitle,self.timeOut] forState:UIControlStateNormal];                    
                }
                [self.btn setTitleColor:self.ingTitleColor forState:UIControlStateNormal];
            }
            if(self.ingBlock){
                self.ingBlock(self.timeOut);
            }
        });
        self.timeOut--;
    }
}

- (void)destroyTimer
{
    if(self.dispatchTimer){
        //关闭定时器
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
    }
}


#pragma mark - lazy

- (dispatch_source_t)dispatchTimer{
    if(!_dispatchTimer){
        CJJWeakSelf(self)
        _dispatchTimer = CJJSMSTimerCreateDispatchTimer(1.0*NSEC_PER_SEC, 0, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                CJJStrongSelf(self)
                [strongself handleEvent];
            });
        });
    }
    return _dispatchTimer;
}

dispatch_source_t CJJSMSTimerCreateDispatchTimer(uint64_t interval,
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

- (void)dealloc
{
    NSLog(@"短信定时器销毁");
    [self destroyTimer];
}

@end
