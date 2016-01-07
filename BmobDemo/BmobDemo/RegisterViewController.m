//
//  RegisterViewController.m
//  BmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "RegisterViewController.h"
#import "MyButton.h"
#import "Tool.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet MyButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)usernameEditingChanged:(UITextField *)sender {
 
    [self checkTextField];
}

- (IBAction)passwordEditingChanged:(UITextField *)sender {

    [self checkTextField];
}

- (void)checkTextField {
    
    if (self.usernameTF.text.length > 0 && self.passwordTF.text.length > 0) {
        self.registerButton.enabled = YES;
    } else {
        self.registerButton.enabled = NO;
    }
}
- (IBAction)registerButtonPressed:(MyButton *)sender {
    
    NSString *passwordMD5String = [Tool MD5StringFromString:_passwordTF.text];
    
    //创建用户对象
    BmobUser *bUser  = [[BmobUser alloc] init];
    bUser.username = _usernameTF.text;
    bUser.password = passwordMD5String;
 
    //邮箱相关
    if (self.emailTF.text.length > 0) {
        bUser.email = _emailTF.text;
    }
    
    //bmob 会自动给邮箱发验证邮件
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful == YES) {
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                 [self.navigationController popViewControllerAnimated:YES];
            });
           
        } else {
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}


@end
