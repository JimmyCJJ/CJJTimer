//
//  CJJTimerJDCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/24.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerJDCell.h"

@interface CJJTimerJDCell ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) CJJTimerView *timer;
@end

@implementation CJJTimerJDCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerJDCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
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

- (void)setViews{_titleL = [UILabel new];
    _titleL.text = @"京东秒杀";
    _titleL.textColor = [UIColor blackColor];
    _titleL.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:self.timer];
}

- (void)setLayout{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL.mas_right).offset(5);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerView];
        configuration.timerHiddenWhenFinished = NO;
        configuration.timerViewWidth = 15;
        configuration.timerViewHeight = 16;
        configuration.timerViewHorizontalInset = 2;
        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+30];
//        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+13*60*60];
        configuration.timerViewCornerRadius = 3;
        configuration.timerViewBackgroundColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        configuration.timerTextLabelFont = [UIFont systemFontOfSize:9 weight:UIFontWeightBold];
        configuration.timerTextLabelColor = [UIColor whiteColor];
        configuration.timerColonLabelFont = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
        configuration.timerColonLabelColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
    }
    return _timer;
}

@end
