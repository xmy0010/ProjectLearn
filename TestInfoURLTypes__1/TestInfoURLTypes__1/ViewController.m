//
//  ViewController.m
//  TestInfoURLTypes__1
//
//  Created by 千锋 on 16/1/11.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "ViewController.h"

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
- (IBAction)backApplication:(UIButton *)sender {
    
    NSString *urlStr = @"APP://";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

@end
