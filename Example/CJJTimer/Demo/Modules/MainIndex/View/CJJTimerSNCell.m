//
//  CJJTimerSNCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerSNCell.h"

@interface CJJTimerSNCell ()
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) CJJTimer *timer;
@end

@implementation CJJTimerSNCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerSNCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
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
    _nameL = [UILabel new];
    
    [self.contentView addSubview:_nameL];
    [self.contentView addSubview:self.timer];
}

- (void)setLayout{
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameL.mas_right).offset(20);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

- (void)setModel:(CJJTimerModel *)model{
    _model = model;
    _nameL.text = _model.name;
}

- (CJJTimer *)timer{
    if(!_timer){
        CJJTimerConfiguration *configuration = [CJJTimerConfiguration configureTimer];
        configuration.timerLastTime = @"1595574877";//1595488477 1595574877
//        configuration.timerViewWidth = 15;
//        configuration.timerViewHeight = 15;
        configuration.timerViewInset = 0;
        configuration.timerColonWidth = 2;
        configuration.timerViewBackgroundColor = [UIColor whiteColor];
        configuration.timerTextLabelFont = [UIFont systemFontOfSize:9 weight:UIFontWeightBold];
        configuration.timerTextLabelColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        configuration.timerColonLabelFont = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
        configuration.timerColonLabelColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        _timer = [CJJTimer timerWithConfiguration:configuration];
        _timer.layer.borderWidth = 0.5;
        _timer.layer.borderColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1].CGColor;
        _timer.layer.cornerRadius = 3;
    }
    return _timer;
}

@end
