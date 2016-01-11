//
//  AppDelegate.m
//  TestInfoURLTypes__1
//
//  Created by 千锋 on 16/1/11.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

//接收从其他app跳过来时 该APP的url(ps:如这样//后面可以带自己想要传递的参数 此处传过来自己的url,例子：url=APP1://APP=APP)
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    NSLog(@"url=%@", url.absoluteString);
    
    NSString *urlString = url.absoluteString;
    NSArray *arr = [urlString componentsSeparatedByString:@"="];
    self.sourceUrlSting = [NSString stringWithFormat:@"%@://", arr.lastObject];

    
    return YES;
}

@end
