//
//  AppDelegate.m
//  CJJTimer
//
//  Created by CJJ on 2020/6/30.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "AppDelegate.h"
#import "CJJIndexVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureWindow];
    
    return YES;
}

- (void)configureWindow{
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:CJJRouterCreatVC(@"CJJIndexVC")];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}



@end
