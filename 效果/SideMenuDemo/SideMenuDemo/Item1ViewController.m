//
//  Item1ViewController.m
//  SideMenuDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "Item1ViewController.h"
#import <RESideMenu.h>

@interface Item1ViewController ()

@end

@implementation Item1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (IBAction)item1Pressed:(UIBarButtonItem *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
