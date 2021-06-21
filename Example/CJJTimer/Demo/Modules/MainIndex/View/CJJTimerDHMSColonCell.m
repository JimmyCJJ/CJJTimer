//
//  CJJTimerDHMSColonCell.m
//  CJJTimer
//
//  Created by 曹鉴津 on 2021/6/10.
//  Copyright © 2021 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerDHMSColonCell.h"
#import "CJJTimer.h"
#import "Masonry.h"
#import "NSObject+TimeExtension.h"

@interface CJJTimerDHMSColonCell ()<CJJTimerViewDelegate>
@property (nonatomic, strong) CJJTimerView *timer;
@end

@implementation CJJTimerDHMSColonCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerDHMSColonCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
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

#pragma mark - CJJTimerViewDelegate

- (void)changeModeInTimerView:(CJJTimerView *)timerView {
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

#pragma mark - lazy

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerViewWithMode:CJJTimerViewMode_DHMS];
        configuration.colonDayLabelText(@"天")
        .colonHourLabelText(@"时")
        .colonMinLabelText(@"分")
        .colonSecLabelText(@"秒")
        .viewWidth(30)
        .viewHeight(30)
        .colonWidth(30)
        .hiddenWhenFinished(NO)
        .lastTime([NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+24*60*60 + 15])
        .cornerRadius(5)
        .backgroundColor([UIColor whiteColor])
        .shadowColor([UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1])
        .shadowOffset(CGSizeMake(0,1.5))
        .shadowOpacity(1)
        .shadowRadius(5)
        .textLabelFont([UIFont systemFontOfSize:20 weight:UIFontWeightBold])
        .textLabelColor([UIColor colorWithRed:253/255.0 green:64/255.0 blue:71/255.0 alpha:1.0])
        .colonLabelFont([UIFont systemFontOfSize:20 weight:UIFontWeightBold])
        .colonLabelColor([UIColor colorWithRed:253/255.0 green:64/255.0 blue:71/255.0 alpha:1.0])
        .autoChangeMode(YES);
        
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
        _timer.delegate = self;
    }
    return _timer;
}

@end
