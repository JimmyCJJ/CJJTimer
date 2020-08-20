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
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
}

- (void)startCountDownAction:(UIButton *)btn{
    BOOL isCustom = NO;
    
    //block设置倒计时前后UI变化
    if(isCustom){
        self.timer = [CJJSMSTimer timerStartCountdownWithBtn:btn timeOut:6 titleIngSettingBlock:^(int sec) {
            [btn setTitle:[NSString stringWithFormat:@"%ds",sec] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor grayColor].CGColor;
        } titleFinishSettingBlock:^{
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor blueColor].CGColor;
        }];
    }else{
        //默认设置方法
        self.timer = [CJJSMSTimer timerStartCountdownWithBtn:btn timeOut:6 ingTitle:@"重新获取" ingTitleColor:[UIColor grayColor] finishedTitle:@"获取验证码" finishedTitleColor:[UIColor blueColor] titleIngSettingBlock:^(int sec) {
            btn.layer.borderColor = [UIColor grayColor].CGColor;
        } titleFinishSettingBlock:^{
            btn.layer.borderColor = [UIColor blueColor].CGColor;
        }];
    }
    
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
