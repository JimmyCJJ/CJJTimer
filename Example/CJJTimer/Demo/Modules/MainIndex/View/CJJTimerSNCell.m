//
//  CJJTimerSNCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerSNCell.h"

@interface CJJTimerSNCell ()
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) CJJTimerView *timer;
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
    _timeL = [UILabel new];
    _timeL.text = @"16点场";
    _timeL.textColor = [UIColor whiteColor];
    _timeL.backgroundColor = [UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1];
    _timeL.font = [UIFont systemFontOfSize:13];
    _timeL.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_timeL];
    [self.contentView addSubview:self.timer];
}

- (void)setLayout{
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeL.mas_right);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

- (void)drawRect:(CGRect)rect{
    [_timeL platFormRadiusViewWithRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
    
    [_timer platFormRadiusViewWithRectCorner:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = ((CAShapeLayer *)_timer.layer.mask).path;
    shape.strokeColor = [UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1].CGColor;//边框色
    shape.lineWidth = 0.5f;//边框宽度
    shape.fillColor = [UIColor clearColor].CGColor;//填充色
    [_timer.layer addSublayer:shape];
}

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerView];
        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+14*60*60];
        configuration.timerViewWidth = 18;
//        configuration.timerViewHeight = 15;
        configuration.timerViewInset = 0;
        configuration.timerColonWidth = 4;
        configuration.timerInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        configuration.timerViewBackgroundColor = [UIColor whiteColor];
        configuration.timerTextLabelFont = [UIFont systemFontOfSize:13];
        configuration.timerTextLabelColor = [UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1];
        configuration.timerColonLabelFont = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
        configuration.timerColonLabelColor = [UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1];
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
    }
    return _timer;
}

@end
