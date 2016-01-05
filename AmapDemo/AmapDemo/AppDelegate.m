//
//  AppDelegate.m
//  AmapDemo
//
//  Created by 千锋 on 15/12/4.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>//高德地图头文件
#import <AMapSearchKit/AMapSearchKit.h>
#import "ViewController.h"

//apikey:@"9c86ffb42ec6f27ae30523f4bee71741" 

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置高德地图的APP KEY
    [MAMapServices sharedServices].apiKey = @"9c86ffb42ec6f27ae30523f4bee71741";
    [AMapSearchServices sharedServices].apiKey = @"9c86ffb42ec6f27ae30523f4bee71741";
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    self.window.rootViewController = navi;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
