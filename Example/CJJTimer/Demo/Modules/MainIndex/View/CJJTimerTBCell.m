//
//  CJJTimerTBCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerTBCell.h"

@interface CJJTimerTBCell ()<CJJTimerViewDelegate>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) CJJTimerView *timer;
@end

@implementation CJJTimerTBCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerTBCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setViews];
        [self setLayout];
    }
    return self;
}

- (void)setViews{
    _titleL = [UILabel new];
    _titleL.text = @"聚划算";
    _titleL.textColor = [UIColor blackColor];
    _titleL.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:self.timer];
}

- (void)setLayout{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(-50);
    }];
    
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL.mas_right).offset(5);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

#pragma mark - CJJTimerDelegate

/// 倒计时结束回调
- (void)timerFinished:(CJJTimerView *)timer{
    NSLog(@"timerFinished倒计时结束回调");
}

#pragma mark - lazy

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerView];
        configuration.timerViewWidth = 18;
        configuration.timerViewHeight = 18;
        configuration.timerHiddenWhenFinished = NO;
        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+10];
//        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+12*60*60];
        configuration.timerViewCornerRadius = 3;
        configuration.timerViewBackgroundColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        configuration.timerTextLabelFont = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
        configuration.timerTextLabelColor = [UIColor whiteColor];
        configuration.timerColonLabelFont = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
        configuration.timerColonLabelColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
        _timer.delegate = self;
    }
    return _timer;
}

@end
