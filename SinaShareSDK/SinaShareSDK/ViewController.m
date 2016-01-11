//
//  ViewController.m
//  SinaShareSDK
//
//  Created by 千锋 on 16/1/11.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openTest:(UIButton *)sender {
    NSString *url = @"Test:Mytest";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (IBAction)shareWeibo:(UIButton *)sender {
    
    //获取appdelegate对象
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //发起授权
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    //设置回调地址url
    authRequest.redirectURI = kRedirectURl;
    //设置请求类型
    authRequest.scope = @"all";
    
    //获取用户令牌
    NSString *token = appDelegate.wbToken;
    //回调地址 （已写入预编译文件）
    
    //生成一个消息对象
    WBMessageObject *messageObj = [WBMessageObject message];
    messageObj.text = @"This gay he has a time mechine";
    
    //消息对象里面的图片
    WBImageObject *imageObj = [WBImageObject object];
    //获取一张图片
    UIImage *image = [UIImage imageNamed:@"Screenshot"];
    //将图片转为二进制图片
    NSData *imageData = UIImagePNGRepresentation(image);
    imageObj.imageData = imageData;
    messageObj.imageObject = imageObj;
    
    
    //生成一个消息请求
    WBSendMessageToWeiboResponse *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObj authInfo:authRequest access_token:token];
    //创建用户自定义消息 (不是消息的文字内容)
    authRequest.userInfo = @{@"ShareMessageFrom": @"ViewController"};
    
    //发送分享消息内容
    [WeiboSDK sendRequest:request];
}

@end
