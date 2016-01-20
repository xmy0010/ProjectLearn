//
//  ViewController.m
//  数字输入
//
//  Created by HeHui on 15/9/6.
//  Copyright (c) 2015年 HeHui. All rights reserved.
//

#import "ViewController.h"

#import "FloatTextField.h"
#import "IntegerTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FloatTextField *tf  = [[FloatTextField alloc] initWithFrame:CGRectMake(100, 100, CGRectGetWidth(self.view.frame) - 200, 30)];
    [self.view addSubview:tf];
    
    tf.backgroundColor = [UIColor greenColor];
    
    
    IntegerTextField *tf2  = [[IntegerTextField alloc] initWithFrame:CGRectMake(100, 300, CGRectGetWidth(self.view.frame) - 200, 30)];
    [self.view addSubview:tf2];
    
    tf2.backgroundColor = [UIColor orangeColor];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
