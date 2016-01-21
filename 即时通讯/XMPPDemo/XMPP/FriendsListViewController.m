//
//  FriendsListViewController.m
//  XMPP
//
//  Created by 千锋 on 16/1/21.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

//FriendCell
#import "FriendsListViewController.h"
#import "HHXmppManager.h"
#import "ChatViewController.h"

@interface FriendsListViewController () <XMPPRosterDelegate>

/**存储好友jid数组*/
@property (nonatomic, strong) NSMutableArray *friendJIDs;

@end

@implementation FriendsListViewController

- (NSMutableArray *)friendJIDs {

    if (_friendJIDs) {
        _friendJIDs = @[].mutableCopy;
    }
    
    return _friendJIDs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理  代理回调·会扫描所有好友
    XMPPRoster *roster = [HHXmppManager sharedManager].xmppRoster;
    [roster addDelegate:self delegateQueue:Queue_back_default];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friendJIDs.count;
}

#define mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    XMPPJID *jid = self.friendJIDs[indexPath.row];
    
    cell.textLabel.text = jid.user;
    
    return cell;
}

#pragma mark <XMPPRosterDelegate>

//收到订阅请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {

    //获取谁发来的好友
    XMPPJID *fromJid = presence.from;
    NSString *msg = [NSString stringWithFormat:@"%@请求加你为好友，是否接受", fromJid.user];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友请求" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //获取Roster
    XMPPRoster *roster = [HHXmppManager sharedManager].xmppRoster;
    
    
    //拒绝
    UIAlertAction *reject = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [roster rejectPresenceSubscriptionRequestFrom:fromJid];
    }];
    
    //接受
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [roster acceptPresenceSubscriptionRequestFrom:fromJid andAddToRoster:YES];
    }];
    
    [alert addAction:reject];
    [alert addAction:accept];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}


//开始扫描
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender withVersion:(NSString *)version {
    NSLog(@"扫描");
    
}

//扫描到item（item包含了好友）
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item {
    NSLog(@"%@", item);
    //判断item信息里面双方（我，发来信息方里面包含的JID用户）是否相互订阅（好友）
    NSString *subScription = [item attributeStringValueForName:@"subscription"];
    
    if ([subScription isEqualToString:@"both"]) {
        
        //获取item里面的用户jid
        NSString *friend = [item attributeStringValueForName:@"jid"];
        XMPPJID *friendJid = [XMPPJID jidWithString:friend];
        
        [self.friendJIDs addObject:friendJid];
        
        //刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

//结束扫描
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender {

}
- (IBAction)addItemPressed:(UIBarButtonItem *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入好友名";
        
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *send = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //发送好友请求
        UITextField *tf = alert.textFields.firstObject;
        NSString *user = tf.text;
        user = [user stringByAppendingFormat:@"@%@", HostIP];
        
        //根据名字创建一个请求好友的JID
        XMPPJID *friendJID = [XMPPJID jidWithString:user];
        
        //发送订阅消息 (好友请求)
        XMPPRoster *roster = [HHXmppManager sharedManager].xmppRoster;
        [roster subscribePresenceToUser:friendJID];
    }];
    
    [alert addAction:cancle];
    [alert addAction:send];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //和特定的好友聊天
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.friendJid = self.friendJIDs[indexPath.row];
    
    
    [self.navigationController pushViewController:chatVC animated:YES];
}


@end
