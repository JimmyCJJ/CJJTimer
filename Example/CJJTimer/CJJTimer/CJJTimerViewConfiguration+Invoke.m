//
//  CJJTimerViewConfiguration+Invoke.m
//  CJJTimer
//
//  Created by wangfeng on 2020/8/18.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerViewConfiguration+Invoke.h"

@implementation CJJTimerViewConfiguration (Invoke)

#pragma mark - Function Config

- (CJJTimerViewConfiguration *(^)(NSString *))lastTime{
    return ^CJJTimerViewConfiguration * (NSString *lastTime){
        self.timerLastTime = lastTime;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(BOOL))autoStart{
    return ^CJJTimerViewConfiguration * (BOOL autoStart){
        self.timerAutoStart = autoStart;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(BOOL))hiddenWhenFinished{
    return ^CJJTimerViewConfiguration * (BOOL hiddenWhenFinished){
        self.timerHiddenWhenFinished = hiddenWhenFinished;
        return self;
    };
}

#pragma mark - UI Config

- (CJJTimerViewConfiguration *(^)(CGFloat))viewWidth{
    return ^CJJTimerViewConfiguration * (CGFloat viewWidth){
        self.timerViewWidth = viewWidth;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGFloat))viewHeight{
    return ^CJJTimerViewConfiguration * (CGFloat viewHeight){
        self.timerViewHeight = viewHeight;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGFloat))horizontalInset{
    return ^CJJTimerViewConfiguration * (CGFloat horizontalInset){
        self.timerViewHorizontalInset = horizontalInset;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGFloat))colonWidth{
    return ^CJJTimerViewConfiguration * (CGFloat colonWidth){
        self.timerColonWidth = colonWidth;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIEdgeInsets))insets{
    return ^CJJTimerViewConfiguration * (UIEdgeInsets insets){
        self.timerInsets = insets;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIColor *))backgroundColor{
    return ^CJJTimerViewConfiguration * (UIColor *backgroundColor){
        self.timerViewBackgroundColor = backgroundColor;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGFloat))cornerRadius{
    return ^CJJTimerViewConfiguration * (CGFloat cornerRadius){
        self.timerViewCornerRadius = cornerRadius;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIColor *))shadowColor{
    return ^CJJTimerViewConfiguration * (UIColor *shadowColor){
        self.timerViewShadowColor = shadowColor;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGSize))shadowOffset{
    return ^CJJTimerViewConfiguration * (CGSize shadowOffset){
        self.timerViewShadowOffset = shadowOffset;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGFloat))shadowOpacity{
    return ^CJJTimerViewConfiguration * (CGFloat shadowOpacity){
        self.timerViewShadowOpacity = shadowOpacity;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(CGFloat))shadowRadius{
    return ^CJJTimerViewConfiguration * (CGFloat shadowRadius){
        self.timerViewShadowRadius = shadowRadius;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIColor *))textLabelColor{
    return ^CJJTimerViewConfiguration * (UIColor *textLabelColor){
        self.timerTextLabelColor = textLabelColor;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIColor *))colonLabelColor{
    return ^CJJTimerViewConfiguration * (UIColor *colonLabelColor){
        self.timerColonLabelColor = colonLabelColor;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIFont *))textLabelFont{
    return ^CJJTimerViewConfiguration * (UIFont *textLabelFont){
        self.timerTextLabelFont = textLabelFont;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(UIFont *))colonLabelFont{
    return ^CJJTimerViewConfiguration * (UIFont *colonLabelFont){
        self.timerColonLabelFont = colonLabelFont;
        return self;
    };
}


- (CJJTimerViewConfiguration *(^)(NSString *))colonHourLabelText{
    return ^CJJTimerViewConfiguration * (NSString *colonHourLabelText){
        self.timerColonHourLabelText = colonHourLabelText;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(NSString *))colonMinLabelText{
    return ^CJJTimerViewConfiguration * (NSString *colonMinLabelText){
        self.timerColonMinLabelText = colonMinLabelText;
        return self;
    };
}

- (CJJTimerViewConfiguration *(^)(NSString *))colonSecLabelText{
    return ^CJJTimerViewConfiguration * (NSString *colonSecLabelText){
        self.timerColonSecLabelText = colonSecLabelText;
        return self;
    };
}



@end
