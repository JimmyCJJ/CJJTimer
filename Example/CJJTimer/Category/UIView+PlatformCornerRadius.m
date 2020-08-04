//
//  UIView+PlatformCornerRadius.m
//  CJJTimer
//
//  Created by CJJ on 2019/12/17.
//  Copyright © 2019 CJJTimer. All rights reserved.
//

#import "UIView+PlatformCornerRadius.h"


@implementation UIView (PlatformCornerRadius)
//注意，必须先设置frame才生效
- (UIBezierPath *)platFormRadiusViewWithRectCorner:(UIRectCorner)corner cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    return maskPath;
}

//弹簧效果动画弹窗
- (void)animationAlertWithSpring
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.6;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    
}

//无弹簧效果动画弹窗
- (void)animationAlertWithoutSpring
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.2;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.9f, @0.95f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)animationHide
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.2;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4f, 0.4f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2f, 0.2f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)]];
    popAnimation.keyTimes = @[@0.1f, @0.3f, @0.5f,@0.7f,@1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    popAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:popAnimation forKey:nil];
    
}

@end
