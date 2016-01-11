//
//  AppDelegate.m
//  ShareSDK
//
//  Created by T_yun on 16/1/11.
//  Copyright © 2016年 T_yun. All rights reserved.
//
#import "ShareHeader.h"

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <WXApi.h>
#import <WeiboSDK.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupShareSDK];
    
    return YES;
}

- (void)setupShareSDK {
    
    [ShareSDK registerApp:AppKey_ShareSDK activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     //导入每个平台
                     switch (platformType) {
                             
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:
                              [WXApi class]];
                             break;
                             
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              //配置每个平台
              switch (platformType) {
                      
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo
                       SSDKSetupSinaWeiboByAppKey:AppKey_Weibo
                       appSecret:AppSecret_Weibo
                       redirectUri:RedirectUri_Weibo
                       authType:SSDKAuthTypeBoth];
                      break;
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo
                       SSDKSetupWeChatByAppId:AppKey_WeChat
                       appSecret: AppSecret_WeChat];
                      break;
                      
                  default:
                      break;
              }
          }];
    
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
