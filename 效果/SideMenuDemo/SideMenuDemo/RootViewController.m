//
//  RootViewController.m
//  SideMenuDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "RootViewController.h"
#import "LeftMenuController.h"
#import "MainTableViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

//当视图从storyboard 或xib中唤醒
- (void)awakeFromNib {
    
    //设置RESideMenu属性
    
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
    
    //边界到中心的偏移量
    self.contentViewInPortraitOffsetCenterX = 150;
    self.contentViewShadowOffset = CGSizeMake(-10, 10);
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 6;
    
    
    

    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //添加左边和中间Vc
    LeftMenuController *leftVC = [mainSb instantiateViewControllerWithIdentifier:@"LeftVC"];
    MainTableViewController *mainVC = [mainSb instantiateViewControllerWithIdentifier:@"MainVC"];
    
    self.leftMenuViewController = leftVC;
    self.contentViewController = mainVC;
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
