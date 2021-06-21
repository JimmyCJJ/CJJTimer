//
//  CJJTimerMacro.h
//  CJJTimer
//
//  Created by JimmyCJJ on 2020/7/25.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#ifndef CJJTimerMacro_h
#define CJJTimerMacro_h

//弱化
#define CJJWeakSelf(type)  __weak typeof(type) weak##type = type;
//代码块里面强化，防止丢失
#define CJJStrongSelf(type) __strong typeof(type) strong##type = weak##type;

#define CJJAbstractMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]

#endif /* CJJTimerMacro_h */
