//
//  NSObject+TimeExtension.h
//  CJJTimer
//
//  Created by CJJ on 2020/7/24.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TimeExtension)

////返回秒为单位的时间戳
- (NSString *)getNowTimeTimeStampSec;

//返回毫秒为单位的时间戳
- (NSString *)getNowTimeTimestampMinSec;


@end

NS_ASSUME_NONNULL_END
