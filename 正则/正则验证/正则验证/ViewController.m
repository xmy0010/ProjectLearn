//
//  ViewController.m
//  正则验证
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//




#import "ViewController.h"

#import <Masonry.h>


NSString *mobileRegex = @"^1([37][0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";

NSString *mobileReg = @"^1[3|4|5|7|8][0-9]\\d{8}$";

NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

#define REGEX_PayPASSWORD_LOWLEVEL @"(?=.*\\d.*)(?=.*\\D.*).{6,20}"         // 支付密码强度低


#define REGEX_PASSWORD_MIDDLELEVEL @"^(?=.*[A-Z].*).{8,}$"                  // 密码强度中

#define REGEX_PASSWORD_HIGHLEVEL @"^(?=.*\\W.*).{10,}$"

@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupSubViews
{
    self.textField = [[UITextField alloc] init];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor cyanColor];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.equalTo(@40);

    }];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"验证" forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = [UIColor orangeColor];
    [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(100);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
        make.centerX.equalTo(self.view);
        
    }];
}

- (void)confirm
{
    // 1. 创建一个谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REGEX_PayPASSWORD_LOWLEVEL];
    // 2. 验证所输入的是否匹配
    if ([predicate evaluateWithObject:self.textField.text]) {
         // 密码强度可用
        // 3.匹配中级强度
        
        NSPredicate *midPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REGEX_PASSWORD_MIDDLELEVEL];
        
        if ([midPre evaluateWithObject:self.textField.text]) {
            // 密码强度至少为中
            NSPredicate *highPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REGEX_PASSWORD_HIGHLEVEL];
            
            if ([highPre evaluateWithObject:self.textField.text]) {
                // 高级强度
            }else {
                // 中级强度
            }
            
            
        }else {
            // 就是低级强度
        }
        
        
        
    }else {
        NSLog(@"密码强度太低");
    }
}



@end
