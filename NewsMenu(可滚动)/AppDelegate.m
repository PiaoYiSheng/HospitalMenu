//
//  AppDelegate.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController * nVC = [[ViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nVC];
    
    self.window.rootViewController = navi;
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
