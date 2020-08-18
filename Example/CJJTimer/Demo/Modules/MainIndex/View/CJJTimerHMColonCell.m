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
        configuration.colonHourLabelText(@"时")
        .colonMinLabelText(@"分")
        .viewWidth(30)
        .viewHeight(30)
        .colonWidth(30)
        .hiddenWhenFinished(NO)
        .lastTime([NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+12*60*60])
        .cornerRadius(5)
        .backgroundColor([UIColor whiteColor])
        .shadowColor([UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1])
        .shadowOffset(CGSizeMake(0,1.5))
        .shadowOpacity(1)
        .shadowRadius(5)
        .textLabelFont([UIFont systemFontOfSize:20 weight:UIFontWeightBold])
        .textLabelColor([UIColor colorWithRed:253/255.0 green:64/255.0 blue:71/255.0 alpha:1.0])
        .colonLabelFont([UIFont systemFontOfSize:20 weight:UIFontWeightBold])
        .colonLabelColor([UIColor colorWithRed:253/255.0 green:64/255.0 blue:71/255.0 alpha:1.0]);
        
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
    }
    return _timer;
}

@end

