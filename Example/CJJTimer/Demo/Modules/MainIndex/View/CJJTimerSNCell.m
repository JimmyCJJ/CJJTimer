//
//  CJJTimerSNCell.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerSNCell.h"
#import "CJJTimer.h"
#import "Masonry.h"

@interface CJJTimerSNCell ()<CJJTimerViewDelegate>
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) CJJTimerView *timer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
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
        make.centerX.mas_equalTo(-40);
        make.height.mas_equalTo(24);
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
    
    [self.contentView layoutIfNeeded];
    
    [_timeL platFormRadiusViewWithRectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
    
    [_timer platFormRadiusViewWithRectCorner:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    
    [_timer.layer addSublayer:self.shapeLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.timer.configuration.timerViewWidth = 100;
}

#pragma mark - CJJTimerViewDelegate

- (void)changeModeInTimerView:(CJJTimerView *)timerView {
    NSLog(@"回调了");
    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
        [self.timer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeL.mas_right);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
        }];
    }];
}

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerViewWithMode:CJJTimerViewMode_HMS];
        configuration.lastTime([NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+16*60*60])
        .viewWidth(18)
        .insets(UIEdgeInsetsMake(0, 4, 0, 4))
        .backgroundColor([UIColor whiteColor])
        .textLabelFont([UIFont systemFontOfSize:13])
        .textLabelColor([UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1])
        .colonLabelFont([UIFont systemFontOfSize:11 weight:UIFontWeightBold])
        .colonLabelColor([UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1]);
        
        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
        _timer.delegate = self;
    }
    return _timer;
}

- (CAShapeLayer *)shapeLayer{
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = ((CAShapeLayer *)_timer.layer.mask).path;
        _shapeLayer.strokeColor = [UIColor colorWithRed:226/255.0 green:41/255.0 blue:39/255.0 alpha:1].CGColor;//边框色
        _shapeLayer.lineWidth = 0.5f;//边框宽度
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充色
    }
    return _shapeLayer;
}



@end
