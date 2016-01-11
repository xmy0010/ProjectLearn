//
//  RootViewController.m
//  BmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "RootViewController.h"
#import "LeftViewController.h"
#import "MainViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


- (void)awakeFromNib {

    //创建
    LeftViewController *leftVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    self.leftMenuViewController = leftVC;
    self.contentViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSideMenu];
}

- (void)setupSideMenu {
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
