//
//  CJJTimerHMColonCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/8/1.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerHMColonCell.h"

@interface CJJTimerHMColonCell ()
@property (nonatomic, strong) CJJTimerView *timer;
@end

@implementation CJJTimerHMColonCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerHMColonCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
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
    [self.contentView addSubview:self.timer];
}

- (void)setLayout{
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

#pragma mark - lazy

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerViewWithMode:CJJTimerViewMode_HM];
        configuration.timerColonHourLabelText = @"时";
        configuration.timerColonMinLabelText = @"分";
        configuration.timerViewWidth = 30;
        configuration.timerViewHeight = 30;
        configuration.timerColonWidth = 30;
        configuration.timerHiddenWhenFinished = NO;
        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+12*60*60];
        configuration.timerViewCornerRadius = 5;
        configuration.timerViewBackgroundColor = [UIColor whiteColor];
        configuration.timerViewShadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        configuration.timerViewShadowOffset = CGSizeMake(0,1.5);
        configuration.timerViewShadowOpacity = 1;
        configuration.timerViewShadowRadius = 5;
        configuration.timerTextLabelFont = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        configuration.timerTextLabelColor = [UIColor colorWithRed:253/255.0 green:64/255.0 blue:71/255.0 alpha:1.0];
        configuration.timerColonLabelFont = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        configuration.timerColonLabelColor = [UIColor colorWithRed:253/255.0 green:64/255.0 blue:71/255.0 alpha:1.0];
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
    }
    return _timer;
}

@end

