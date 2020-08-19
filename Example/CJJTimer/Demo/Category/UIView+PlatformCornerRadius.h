//
//  UIView+PlatformCornerRadius.h
//  CJJTimer
//
//  Created by Jimmy on 2019/12/17.
//  Copyright © 2019 CJJTimer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PlatformCornerRadius)

#pragma mark - 设置view各个方向圆角

/// 设置view各个方向圆角
/// @param corner 方向（可多个|）
/// @param cornerRadii 圆角的大小
- (UIBezierPath *)platFormRadiusViewWithRectCorner:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii;

/// 带弹簧效果弹窗
- (void)animationAlertWithSpring;
/// 不带弹簧效果弹窗
- (void)animationAlertWithoutSpring;
/// 弹窗消失动画
- (void)animationHide;

@end

NS_ASSUME_NONNULL_END
