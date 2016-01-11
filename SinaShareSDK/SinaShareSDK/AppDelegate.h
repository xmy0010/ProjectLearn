//
//  AppDelegate.h
//  SinaShareSDK
//
//  Created by 千锋 on 16/1/11.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**微博授权令牌*/
@property (nonatomic, copy) NSString *wbToken;


/** 微博当前授权用户ID*/
@property (nonatomic, copy) NSString *wbCurrentUserID;

@end

