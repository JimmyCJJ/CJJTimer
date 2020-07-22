//
//  CJJIndexVC.m
//  CJJTimer
//
//  Created by CJJ on 2020/6/30.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJIndexVC.h"

@interface CJJIndexVC ()
@property (nonatomic, strong) CJJTimer *timer;
@end

@implementation CJJIndexVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self setUpLayout];
}


#pragma mark - set up

- (void)setUpView{
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.timer];
    [self.timer beginTimer];
}

- (void)setUpLayout{
    [self.timer configureLayout:^(CGFloat width, CGFloat height) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }];
}

#pragma mark - action


#pragma mark - lazy

- (CJJTimer *)timer{
    if(!_timer){
        CJJTimerConfiguration *configuration = [CJJTimerConfiguration configureTimer];
        configuration.timerLastTime = @"199551280000";
        _timer = [CJJTimer timerWithConfigure:configuration];
    }
    return _timer;
}

@end
