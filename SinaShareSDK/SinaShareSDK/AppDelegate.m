//
//  AppDelegate.m
//  SinaShareSDK
//
//  Created by 千锋 on 16/1/11.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"


@interface AppDelegate () <WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WeiboSDK registerApp:kAppKey];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark <WeiboSDKDelegate>  //two methods required
/**收到微博的应答*/
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {

    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        
        //记录token和用户ID
        WBSendMessageToWeiboResponse *resp = (WBSendMessageToWeiboResponse *)response;
        NSString *token = resp.authResponse.accessToken;
        if (token) {
            self.wbToken = token;
        }
        NSString *userID = resp.authResponse.userID;
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    } else {
        
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {

}

@end
