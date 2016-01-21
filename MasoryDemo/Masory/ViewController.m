//
//  ViewController.m
//  Masory
//
//  Created by T_yun on 16/1/19.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>


NSString *mobileRegex = @"^1([37][0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
NSString *mobileReg = @"^1[34578][0-9]\\d{8}$";
NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

#define REGEX_PayPASSWORD_LOWLEVEL @"(?=.*\\d.*)(?=.*\\D.*).{6,20}"         // 支付密码强度低
#define REGEX_PASSWORD_MIDDLELEVEL @"^(?=.*[A-Z].*).{8,}$"                  // 密码强度中
#define REGEX_PASSWORD_HIGHLEVEL @"^(?=.*\\W.*).{10,}$"


@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {

    self.textField = [[UITextField alloc] init];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor orangeColor];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.height.equalTo(@40);
    }];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton setTitle:@"验证" forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor orangeColor];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.textField.mas_bottom).offset(100);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
        make.centerX.equalTo(self.view);
    }];
    
    [self.confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmButtonPressed:(UIButton *)sender {

    //1.创建一个谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", mobileReg];
    
    //2.验证输入是否匹配
    if ([predicate evaluateWithObject:self.textField.text]) {
        NSLog(@"是手机号");
    } else {
        NSLog(@"不是手机号");
    }
}

@end
