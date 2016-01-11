//
//  LoginViewController.m
//  BmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "LoginViewController.h"
#import "MyButton.h"
#import "Tool.h"


@interface LoginViewController () {

    NSLock *_lock;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet MyButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lock = [[NSLock alloc] init];
    self.loginButton.enabled = NO;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action

- (IBAction)usernameTFEditingChanged:(UITextField *)sender {
    
    [self checkTextField];
}

- (void)tapTest {
    NSLog(@"tap");
}

- (IBAction)passwordTFEditingChanged:(UITextField *)sender {
   
    [self checkTextField];
}

- (IBAction)loginButtonPressed:(MyButton *)sender {

    [_lock lock];

    [SVProgressHUD showWithStatus:@"Loging..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *passwordMD5String = [Tool MD5StringFromString:_passwordTF.text];
    [BmobUser loginInbackgroundWithAccount:_usernameTF.text andPassword:passwordMD5String block:^(BmobUser *user, NSError *error) {
       
       if (user) {
           
           [SVProgressHUD showSuccessWithStatus:@"登录成功"];
           [[NSNotificationCenter defaultCenter] postNotificationName:User_Refresh_Notice object:nil];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
               [self.navigationController popToRootViewControllerAnimated:YES];
           });
       } else {
           [SVProgressHUD showErrorWithStatus:error.localizedDescription];
       }
   }];
    
    [_lock unlock];
}

- (void)checkTextField {
    
    if (self.usernameTF.text.length > 0 && self.passwordTF.text.length > 0) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

@end
