//
//  LeftViewController.m
//  BmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "LeftViewController.h"
#import "MyImageView.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"

@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet MyImageView *tableView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg05"]];
  
    [self userRefresh:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefresh:) name:User_Refresh_Notice object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)userIconTapAction:(UITapGestureRecognizer *)sender {
   
    UIViewController *VC = nil;
    
    if ([BmobUser getCurrentUser]) {
        
        UserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        VC = userInfoVC;
    } else {
    
        //登录
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        VC = loginVC;
    }
    
    UINavigationController *navigationC = (UINavigationController *) self.sideMenuViewController.contentViewController;
    [self.sideMenuViewController hideMenuViewController];
    [navigationC pushViewController:VC animated:YES];
}

- (void)userRefresh:(NSNotification *)notice {

    //获取到用户的用户名(从沙盒中取 bmob会自动将用户信息存入沙盒)
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    if (bUser) {
        
        self.username.text = bUser.username;
        NSString *urlString = [bUser objectForKey:@"userIconUrl"];
        if (urlString == nil) {
            return;
        }
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlString]];
    } else {
        
        self.username.text = @"点击头像登录";
        self.userIcon.image = [UIImage imageNamed:@"avatar_default_big"];
    }
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:User_Refresh_Notice object:nil];
}

@end
