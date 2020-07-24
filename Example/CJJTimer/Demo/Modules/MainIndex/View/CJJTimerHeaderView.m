//
//  CJJTimerHeaderView.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/24.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerHeaderView.h"

@interface CJJTimerHeaderView ()
@property (nonatomic, strong) UILabel *nameL;
@end

@implementation CJJTimerHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setViews];
        [self setLayout];
    }
    return self;
}

- (void)setViews{
    _nameL = [UILabel new];
    
    [self addSubview:_nameL];
}

- (void)setLayout{
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setModel:(CJJTimerModel *)model{
    _model = model;
    _nameL.text = _model.name;
}

@end
