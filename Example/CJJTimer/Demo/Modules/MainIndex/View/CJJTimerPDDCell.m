//
//  CJJTimerPDDCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/24.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerPDDCell.h"
#import "CJJTimer.h"
#import "Masonry.h"

@interface CJJTimerPDDCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) CJJTimerView *timer;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *suspendBtn;
@property (nonatomic, strong) UIButton *resumeBtn;
@property (nonatomic, strong) UIButton *resetBtn;
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
    [self.contentView addSubview:self.coverView];
    [self.coverView addSubview:self.startBtn];
    [self.coverView addSubview:self.stopBtn];
    [self.coverView addSubview:self.suspendBtn];
    [self.coverView addSubview:self.resumeBtn];
    [self.coverView addSubview:self.resetBtn];
}

- (void)setLayout{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timer.mas_top).offset(-5);
        make.left.mas_equalTo(_titleL.mas_left).offset(-5);
        make.right.mas_equalTo(_timer.mas_right).offset(5);
        make.bottom.mas_equalTo(_timer.mas_bottom).offset(5);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-30);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(18);
    }];
    
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL.mas_right);
            make.centerY.mas_equalTo(self.titleL);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.timer.mas_bottom).offset(10);
    }];
    
    [_coverView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [_coverView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)btnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
            [self.timer startTimer];
            break;
        case 102:
            [self.timer stopTimer];
            break;
        case 103:
            [self.timer suspendTimer];
            break;
        case 104:
            [self.timer resumeTimer];
            break;
        case 105:
            [self.timer resetTimerWithlastTime:[NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+22*60*60]];
            break;
        default:
            break;
    }
}

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerView];
        configuration.autoStart(NO)
        .viewWidth(14)
        .viewHeight(16)
        .lastTime([NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+15*60*60])
        .cornerRadius(3)
        .backgroundColor([UIColor clearColor])
        .textLabelFont([UIFont systemFontOfSize:10])
        .textLabelColor([UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1])
        .colonLabelFont([UIFont systemFontOfSize:10])
        .colonLabelColor([UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1]);
        
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
    }
    return _timer;
}

- (UIView *)coverView{
    if(!_coverView){
        _coverView = [UIView new];
    }
    return _coverView;
}

- (UIButton *)startBtn{
    if(!_startBtn){
        _startBtn = [UIButton new];
        [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _startBtn.tag = 101;
        [_startBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)stopBtn{
    if(!_stopBtn){
        _stopBtn = [UIButton new];
        [_stopBtn setTitle:@"结束" forState:UIControlStateNormal];
        [_stopBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _stopBtn.tag = 102;
        [_stopBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopBtn;
}

- (UIButton *)suspendBtn{
    if(!_suspendBtn){
        _suspendBtn = [UIButton new];
        [_suspendBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_suspendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _suspendBtn.tag = 103;
        [_suspendBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _suspendBtn;
}

- (UIButton *)resumeBtn{
    if(!_resumeBtn){
        _resumeBtn = [UIButton new];
        [_resumeBtn setTitle:@"恢复" forState:UIControlStateNormal];
        [_resumeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _resumeBtn.tag = 104;
        [_resumeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resumeBtn;
}

- (UIButton *)resetBtn{
    if(!_resetBtn){
        _resetBtn = [UIButton new];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _resetBtn.tag = 105;
        [_resetBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

@end
