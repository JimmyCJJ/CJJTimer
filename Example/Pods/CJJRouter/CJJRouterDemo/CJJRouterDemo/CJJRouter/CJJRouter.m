//
//  CJJRouter.m
//  CAOJIANJIN
//
//  Created by JimmyCJJ on 2020/5/22.
//  github   : https://github.com/JimmyCJJ
//  wechat   : cjj_ohyeah
//  E-mail   : 403327747@qq.com
//  jianshu  : https://www.jianshu.com/u/fd9922e50c1a
//  欢迎同行一起交流
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJRouter.h"
#import "CJJRouterFailVC.h"

//ignore selector unknown warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface CJJRouter ()
@property (nonatomic,strong) CJJRouterFailVC *defaultFailVC;

@property (nonatomic,copy,nullable) NSString *failVC;
@property (nonatomic,copy,nullable) NSDictionary *failParmas;
@property (nonatomic,copy,nullable) NSString *failSelectorName;
@property (nonatomic,assign) BOOL isFailCustomInitMethod;

@end

@implementation CJJRouter

#pragma mark - 单例

+ (CJJRouter *)sharedCJJRouter{
    static CJJRouter *sharedCJJRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCJJRouter = [[self alloc] init];
    });
    return sharedCJJRouter;
}

#pragma mark - public method

- (UIViewController *)creatVCWithName:(NSString *)vcName{
    UIViewController *vc = [NSClassFromString(vcName) new];
    UIViewController *verifyVC = [self verifyVCWithVC:vc];
    if(verifyVC){
        vc = [verifyVC init];
    }
    return vc;
}

- (UIViewController *)creatVCWithInitMethodWithName:(NSString *)vcName
                                                   params:(NSDictionary *)paramsMuDic{
    return [self creatVCWithName:vcName params:paramsMuDic paramsSelectorName:@"initWithParams:" isCustomInitMethod:YES];
}

- (UIViewController *)creatVCWithNormalMethodWithName:(NSString *)vcName
                                               params:(NSDictionary *)paramsMuDic{
    return [self creatVCWithName:vcName params:paramsMuDic paramsSelectorName:@"setWithParams:" isCustomInitMethod:NO];
}

- (UIViewController *)creatVCWithName:(NSString *)vcName
                               params:(NSDictionary *)paramsMuDic
                   paramsSelectorName:(NSString * )paramsSelectorName
                   isCustomInitMethod:(BOOL)isCustomInitMethod{
    
    NSMutableDictionary *params = [paramsMuDic mutableCopy];
    
    //带上标识
    [params setObject:vcName forKey:@"RouterKey"];
    
    SEL paramsSelector = NSSelectorFromString(paramsSelectorName);
    
    UIViewController *vc = [NSClassFromString(vcName) alloc];
    UIViewController *verifyVC = [self verifyVCWithVC:vc];
    if(verifyVC){
        vc = verifyVC;//replace vc with failVC
        paramsSelector = NSSelectorFromString(_failSelectorName);
        params = [_failParmas mutableCopy];
        isCustomInitMethod = _isFailCustomInitMethod;
    }
    
    if(isCustomInitMethod){
        if(![vc respondsToSelector:paramsSelector]){
            NSLog(@"找不到该参数方法，请检查方法名！");
            return [vc init];
        }
    }else{
        vc = [vc init];
        if(![vc respondsToSelector:paramsSelector]){
            NSLog(@"找不到该参数方法，请检查方法名！");
            return vc;
        }
    }
    SuppressPerformSelectorLeakWarning([vc performSelector:paramsSelector withObject:params]);
    
    return vc;
}

- (void)creatFailVCWithName:(NSString *)failVCName
           failSelectorName:(NSString * __nullable)failSelectorName
                 failParams:(NSDictionary * __nullable)failParams
         isCustomInitMethod:(BOOL)isFailCustomInitMethod{
    _failVC = failVCName;
    _failSelectorName = failSelectorName;
    _failParmas = failParams;
    _isFailCustomInitMethod = isFailCustomInitMethod;
}

- (UIViewController * __nullable)verifyVCWithVC:(UIViewController * __nullable)vc{
    if(!vc){
        NSLog(@"找不到该类，请检查类名！");
        if(![self p_stringNull:self.failVC]){
            UIViewController *vc = [NSClassFromString(self.failVC) alloc];
            if(vc){
                return vc;
            }
        }
        return self.defaultFailVC;
    }
    return nil;
}

- (void)resetFailVC{
    _failVC = nil;
    _failSelectorName = nil;
    _failParmas = nil;
    _isFailCustomInitMethod = NO;
}

#pragma mark - private method

//判断字符串 str 是否为空
- (BOOL)p_stringNull:(NSString *)str {
    if ([str isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (!([str description].length > 0) || str == nil || [str isEqual:@""]) {
        return YES;
    }
    return NO;
}

#pragma mark - lazy

- (CJJRouterFailVC *)defaultFailVC{
    if(!_defaultFailVC){
        _defaultFailVC = [CJJRouterFailVC alloc];
    }
    return _defaultFailVC;
}

@end
