//
//  ChatViewController.h
//  XMPP
//
//  Created by 千锋 on 16/1/21.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHXmppManager.h"

@interface ChatViewController : UIViewController

/**聊天对象的jid*/
@property (nonatomic, strong) XMPPJID *friendJid;

@end
