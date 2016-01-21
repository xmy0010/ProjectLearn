//
//  ChatViewController.m
//  XMPP
//
//  Created by 千锋 on 16/1/21.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "ChatViewController.h"

#define ScreenSize [UIScreen mainScreen].bounds.size

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, XMPPStreamDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ChatViewController


- (NSMutableArray *)messageArray {
    
    if (_messageArray) {
        _messageArray = @[].mutableCopy;
    }
    return _messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"与%@聊天中", self.friendJid.user];
    
    [[HHXmppManager sharedManager].xmppStream addDelegate:self delegateQueue:Queue_back_default];
    
    
    //获取当前登录用户和好友的聊天记录
    [self getMessages];
    
    [self createTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - 100)];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, ScreenSize.height - 40, 250, 30)];
    self.textField.background = [UIColor greenColor];
    
    [self.view addSubview:self.textField];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(280, ScreenSize.height - 40, 60, 30) ;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendButtonPressed:(UIButton *)sender {

    if (self.textField.text.length == 0) {
        
    }else {
        //创建一个消息对象
        XMPPMessage *msg = [XMPPMessage messageWithType:@"Chat" to:self.friendJid];
        [msg addBody:self.textField.text];
        
        //发送
        [[HHXmppManager sharedManager].xmppStream sendElement:msg];
    }
}

- (void)getMessages {

    //获取消息仓库
    XMPPMessageArchivingCoreDataStorage *messageStorage = [HHXmppManager sharedManager].messageStorage;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:messageStorage.messageEntityName inManagedObjectContext:messageStorage.mainThreadManagedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //谓词  用来筛选
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.friendJid.bare];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    //按时间升序来筛选
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [messageStorage.mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
    } else {
    
        if (self.messageArray.count) {
            [self.messageArray removeAllObjects];
        }
        [self.messageArray addObjectsFromArray:fetchedObjects];
        
        //刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    XMPPMessageArchiving_Message_CoreDataObject *messageCDObj = self.messageArray[indexPath.row];
    XMPPMessage *messageObj = messageCDObj.message;
    
    NSString *message = messageObj.body;
    
    //判断是谁发出的消息
    if ([messageCDObj isOutgoing]) {
        message = [NSString stringWithFormat:@"%@: %@", [HHXmppManager sharedManager].xmppStream.myJID.user, message];
    } else {
    
        message = [NSString stringWithFormat:@"%@: %@", self.friendJid.user, message];
    }
    
    
    cell.textLabel.text = message;
    
    
    return cell;
}

#pragma mark XMPPStreamDelegate 
//接受到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMessages];
    });
}

//发出消息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMessages];
    });
}


@end
