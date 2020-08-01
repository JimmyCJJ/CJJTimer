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
    
    if([_timer.layer.sublayers containsObject:self.shapeLayer]){
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    [_timer.layer addSublayer:self.shapeLayer];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.timer.configuration.timerColonHourLabelText = @"时";
//    self.timer.configuration.timerColonMinLabelText = @"分";
//    self.timer.configuration.timerColonSecLabelText = @"秒";
//    self.timer.configuration.timerColonWidth = 20;
//    [self.timer configureLayout:^(CGFloat timerWidth, CGFloat timerHeight) {
//        [self.timer mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(timerWidth, timerHeight));
//        }];
//    }];
//    [self setNeedsDisplay];
//}

- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerView];
        configuration.timerLastTime = [NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+14*60*60];
        configuration.timerViewWidth = 18;
//        configuration.timerViewHeight = 15;
        configuration.timerViewHorizontalInset = 0;
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
