//
//  CJJIndexVC.m
//  CJJTimer
//
//  Created by CJJ on 2020/6/30.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJIndexVC.h"
#import "Masonry.h"

@interface CJJIndexVC ()
@property (nonatomic, strong) UIButton *enterBtn;
@end

@implementation CJJIndexVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self setUpLayout];
}

#pragma mark - set up

- (void)setUpView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.enterBtn];
}

- (void)setUpLayout{
    [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

#pragma mark - action

- (void)goToNextVC:(UIButton *)btn{
    [self.navigationController pushViewController:CJJRouterCreatVC(@"CJJTimerVC") animated:YES];
}

#pragma mark - lazy

- (UIButton *)enterBtn{
    if(!_enterBtn){
        _enterBtn = [UIButton new];
        [_enterBtn setTitle:@"点击进入倒计时" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(goToNextVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

@end
