//
//  CJJTimerPDDCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/24.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerPDDCell.h"

@interface CJJTimerPDDCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) CJJTimer *timer;
@end

@implementation CJJTimerPDDCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerPDDCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
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
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor colorWithRed:254/255.0 green:246/255.0 blue:224/255.0 alpha:1];
    _backView.layer.cornerRadius = 3;
    
    _titleL = [UILabel new];
    _titleL.text = @"距结束";
    _titleL.textColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
    _titleL.font = [UIFont systemFontOfSize:10];
    
    [self.contentView addSubview:_backView];
    [self.contentView addSubview:_titleL];
    [self.contentView addSubview:self.timer];
}

- (void)setLayout{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timer.mas_top).offset(-5);
        make.left.mas_equalTo(_titleL.mas_left).offset(-5);
        make.right.mas_equalTo(_timer.mas_right).offset(5);
        make.bottom.mas_equalTo(_timer.mas_bottom).offset(5);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL.mas_right);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

- (CJJTimer *)timer{
    if(!_timer){
        CJJTimerConfiguration *configuration = [CJJTimerConfiguration configureTimer];
        configuration.timerViewWidth = 14;
        configuration.timerViewHeight = 16;
        configuration.timerViewInset = 0;
        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+15*60*60];
        configuration.timerViewCornerRadius = 3;
        configuration.timerViewBackgroundColor = [UIColor clearColor];
        configuration.timerTextLabelFont = [UIFont systemFontOfSize:10];
        configuration.timerTextLabelColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        configuration.timerColonLabelFont = [UIFont systemFontOfSize:10];
        configuration.timerColonLabelColor = [UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1];
        _timer = [CJJTimer timerWithConfiguration:configuration];
    }
    return _timer;
}

@end
