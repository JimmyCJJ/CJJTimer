//
//  CJJTimerSMSCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/25.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerSMSCell.h"

@interface CJJTimerSMSCell ()
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) CJJSMSTimer *timer;
@end

@implementation CJJTimerSMSCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView{
    NSString * const cellID = NSStringFromClass([self class]);
    CJJTimerSMSCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
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
    [self.contentView addSubview:self.codeBtn];
}

- (void)setLayout{
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (void)startCountDownAction:(UIButton *)btn{
    self.timer = [CJJSMSTimer timerStartCountdownWithBtn:btn timeOut:6 finishedTitle:@"获取验证码" finishedTitleColor:[UIColor blueColor] ingTitle:@"重新获取" ingTitleColor:[UIColor grayColor] titleFinishSettingBlock:^{
        btn.layer.borderColor = [UIColor blueColor].CGColor;
    } titleIngSettingBlock:^{
        btn.layer.borderColor = [UIColor grayColor].CGColor;
    }];
    
}

- (UIButton *)codeBtn{
    if(!_codeBtn){
        _codeBtn = [UIButton new];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _codeBtn.layer.cornerRadius = 20;
        _codeBtn.layer.borderWidth = 0.5;
        _codeBtn.layer.borderColor = [UIColor blueColor].CGColor;
        [_codeBtn addTarget:self action:@selector(startCountDownAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}


@end
