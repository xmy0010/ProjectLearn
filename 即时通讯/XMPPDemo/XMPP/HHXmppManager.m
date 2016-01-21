//
//  HHXmppManager.m
//  XMPP
//
//  Created by 千锋 on 16/1/20.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "HHXmppManager.h"


/**发起管道连接的目的 登录&注册*/
typedef NS_ENUM(NSInteger, ConnectToServerPurpose) {
    
    ConnectToServerPurposeLogin,
    ConnectToServerPurposeRegister
};

@interface HHXmppManager () <XMPPStreamDelegate>



/**临时存储的用户名和密码*/
@property (nonatomic, copy) NSString *tempUsername;
@property (nonatomic, copy) NSString *tempPassword;

/**存储登录结果回调Block*/
@property (nonatomic, copy) LoginBlock loginBlk;

/**临时存储注册结果回调Block*/
@property (nonatomic, copy) RegisterBlock registerBlk;

/**标志识别发起管道连接的目的*/
@property (nonatomic, assign) ConnectToServerPurpose purpose;

@end

@implementation HHXmppManager

- (instancetype)init
{
    //创建异常 并抛出
    NSException *exception = [NSException exceptionWithName:@"提示" reason:@"不能用init方法初始化" userInfo:nil];
    @throw exception;
}

+(instancetype)sharedManager {
    static HHXmppManager *g_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_manager = [[HHXmppManager alloc] initCustom];
    });
    
    return g_manager;
}

- (instancetype)initCustom {

    if (self = [super init]) {
        //初始化管道
        self.xmppStream = [[XMPPStream alloc] init];
        //设置主机地址
        self.xmppStream.hostName = HostIP;
        //设置主机端口号
        self.xmppStream.hostPort = HostPort;
        
        //设置代理
        [self.xmppStream addDelegate:self delegateQueue: Queue_back_default];
        
        //初始化花名册
        //获取花名册CoreData
        XMPPRosterCoreDataStorage *cdStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:cdStorage dispatchQueue:Queue_back_default];
        //激活花名册
        [self.xmppRoster activate:self.xmppStream];
        
        //初始化消息归档管理对象 和消息管理仓库对象并关联
        self.messageStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        
        
        self.xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.messageStorage dispatchQueue:Queue_back_default];
        
        //激活
        [self.xmppMessageArchiving activate:self.xmppStream];
    }
    return self;
}

/**登录*/
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password result:(LoginBlock)loginBlock {

    // 1.配置所需信息
    self.tempUsername = userName;
    self.tempPassword = password;
    self.loginBlk = loginBlock;
    self.purpose = ConnectToServerPurposeLogin;
    
    

    [self connectToServer];
}

/**注册*/
- (void)registerWithUsername:(NSString *)username password:(NSString *)password result:(RegisterBlock)registerBlock {

    self.tempUsername = username;
    self.tempPassword = password;
    self.registerBlk = registerBlock;
    self.purpose = ConnectToServerPurposeRegister;
    
    [self connectToServer];
    
}

/**和服务器建立连接*/
- (void)connectToServer {

    //1.根据传入用户名创建一个jid
    XMPPJID *jid = [XMPPJID jidWithString:self.tempUsername];
    
    //2.设置当前管道的JID对象
    self.xmppStream.myJID = jid;
    
    
     //3.判断账号是否已经在想或是否正在连接 (登录时候判断)
    if (self.purpose == ConnectToServerPurposeLogin) {
        if ([self.xmppStream isConnected] || [self.xmppStream isConnecting]) {
            
            //创建一个下线状态
            XMPPPresence *offlinePresence = [XMPPPresence presenceWithType:@"unavailable"];
            
            //让管道通知服务器下线
            [self.xmppStream sendElement:offlinePresence];
            
            //断开连接
            [self.xmppStream disconnect];
        }
    }
    
    //3.建立通道连接
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:6 error:&error];
    if (error) {
        NSLog(@"connectError:__%d__%@__",__LINE__, error.localizedDescription);
    }

}

#pragma mark <XMPPStreamDelegate>

//建立管道连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {

  
    NSError *error = nil;
    switch (self.purpose) {
        case ConnectToServerPurposeLogin: {
            
              //发起登录
            [self.xmppStream authenticateWithPassword:self.tempPassword error:&error];
        }
            break;
        case ConnectToServerPurposeRegister: {
        
            //发起注册
            [self.xmppStream registerWithPassword:self.tempPassword error:&error];
        }
            break;
    }
    if (error) {
        NSLog(@"connectError:__%d__%@__",__LINE__, error.localizedDescription);
    }
}
//建立管道连接失败
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    switch (self.purpose) {
        case ConnectToServerPurposeLogin: {
            
            self.loginBlk(NO, error);
        }
            break;
        case ConnectToServerPurposeRegister: {
            
            self.registerBlk(NO, error);
        }
            break;
    }
    
    NSLog(@"connectError:__%d__%@__",__LINE__, error.localizedDescription);
}

//建立管道连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {

    NSLog(@"连接超时");
}

#pragma mark - 登录回调
//授权成功（登录成功）
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {

    //需要向服务器发送上线状态
    XMPPPresence *online = [XMPPPresence presenceWithType:@"aivilabel"];
    [self.xmppStream sendElement:online];
    
    
    self.loginBlk(YES,nil);
}
//授权失败（登录失败）
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {

    self.loginBlk(NO, error);
}

#pragma mark - 注册回调

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {

    self.registerBlk(YES, nil);
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {

    self.registerBlk(NO, error);
}


@end
