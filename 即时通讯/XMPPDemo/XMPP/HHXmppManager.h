//
//  HHXmppManager.h
//  XMPP
//
//  Created by 千锋 on 16/1/20.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>
#import <XMPPRoster.h>
#import <XMPPRosterCoreDataStorage.h>
#import <XMPPMessageArchiving.h>
#import <XMPPMessageArchivingCoreDataStorage.h>

/**登录结果回调*/
typedef void(^LoginBlock)(BOOL isSuccess, id error);
/**注册结果回调*/
typedef void(^RegisterBlock)(BOOL isSuccess, id error);

@interface HHXmppManager : NSObject


/**XMPP通道 连接 登录 注册等操作都需要这个通道完成*/
@property (nonatomic, strong) XMPPStream *xmppStream;

/**花名册*/
@property (nonatomic, strong) XMPPRoster *xmppRoster;

/**聊天消息归档管理对象*/
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;

/**聊天消息仓库*/
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *messageStorage;

/**管理类单例*/
+ (instancetype)sharedManager;

/**登录*/
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password result:(LoginBlock)loginBlock;

/**注册*/
- (void)registerWithUsername:(NSString *)username password:(NSString *)password result:(RegisterBlock) registerBlock;

@end
