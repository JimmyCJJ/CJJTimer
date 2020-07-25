//
//  CJJSMSTimer.m
//  CJJTimer
//
//  Created by CJJ on 2020/2/20.
//  Copyright © 2020 CJJTimer. All rights reserved.
//

#import "CJJSMSTimer.h"
#import "CJJTimerMacro.h"
@interface CJJSMSTimer()
@property (nonatomic, strong) dispatch_source_t dispatchTimer;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, copy) NSString *finishedTitle;
@property (nonatomic, strong) UIColor *finishedTitleColor;
@property (nonatomic, copy) NSString *ingTitle;
@property (nonatomic, strong) UIColor *ingTitleColor;
@property (nullable, nonatomic, copy) CJJSMSTimerBlock finishedBlock;
@property (nullable, nonatomic, copy) CJJSMSTimerBlock ingBlock;
@end
@implementation CJJSMSTimer

/** 开启倒计时 */
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                          finishedTitle:(NSString *)finishedTitle
                      finishedTitleColor:(UIColor *)finishedTitleColor
                               ingTitle:(NSString *)ingTitle
                           ingTitleColor:(UIColor *)ingTitleColor{
                               return [self timerStartCountdownWithBtn:btn timeOut:timeOut finishedTitle:finishedTitle finishedTitleColor:finishedTitleColor ingTitle:ingTitle ingTitleColor:ingTitleColor titleFinishSettingBlock:nil titleIngSettingBlock:nil];
}

/** 开启倒计时 */
+ (instancetype)timerStartCountdownWithBtn:(UIButton *)btn
                               timeOut:(int)timeOut
                          finishedTitle:(NSString *)finishedTitle
                      finishedTitleColor:(UIColor *)finishedTitleColor
                               ingTitle:(NSString *)ingTitle
                           ingTitleColor:(UIColor *)ingTitleColor
                   titleFinishSettingBlock:(CJJSMSTimerBlock __nullable)finishedBlock
                      titleIngSettingBlock:(CJJSMSTimerBlock __nullable)ingBlock{
    CJJSMSTimer *timer = [[CJJSMSTimer alloc] init];
    timer.btn = btn;
    timer.timeOut = timeOut;
    timer.finishedTitle = finishedTitle;
    timer.finishedTitleColor = finishedTitleColor;
    timer.ingTitle = ingTitle;
    timer.ingTitleColor = ingTitleColor;
    timer.finishedBlock = finishedBlock;
    timer.ingBlock = ingBlock;
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
            //倒计时结束的按钮显示 根据自己需求设置
            [self.btn setTitle:self.finishedTitle forState:UIControlStateNormal];
            [self.btn setTitleColor:self.finishedTitleColor forState:UIControlStateNormal];
            self.btn.enabled=YES;
            if(self.finishedBlock){
                self.finishedBlock();
            }
        });
    }else{
        //倒计时中
        //显示倒计时结果
        NSString *strTime = [NSString stringWithFormat:@"%@%.2ds",self.ingTitle,self.timeOut];
        dispatch_async(dispatch_get_main_queue(), ^{
            //倒计时中的按钮显示 根据自己需求设置
            [self.btn setTitle:[NSString stringWithFormat:@"%@", strTime] forState:UIControlStateNormal];
            [self.btn setTitleColor:self.ingTitleColor forState:UIControlStateNormal];
            self.btn.enabled = NO;
            if(self.ingBlock){
                self.ingBlock();
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
        kWeakSelf(self)
        _dispatchTimer = CJJSMSTimerCreateDispatchTimer(1.0*NSEC_PER_SEC, 0, dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                kStrongSelf(self)
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
