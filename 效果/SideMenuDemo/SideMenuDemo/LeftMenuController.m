//
//  LeftMenuController.m
//  SideMenuDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "LeftMenuController.h"
#import <RESideMenu.h>

@interface LeftMenuController ()

@end

@implementation LeftMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //cell选中
    switch (indexPath.row) {
        case 0: {
            UIViewController *VC = [[UIViewController alloc] init];
            VC.view.backgroundColor = [UIColor yellowColor];
            VC.title = @"购买会员";
            VC.hidesBottomBarWhenPushed = YES;
            
            //1.获取contentViewController
            UITabBarController *tabBarVC = (UITabBarController *)self.sideMenuViewController.contentViewController;
            
            //2.获取tabBar当前显示的那个ViewController(是navigationC)
            UINavigationController *navigationC = (UINavigationController *)tabBarVC.selectedViewController;
            
            //3.推出目标视图控制器
            [navigationC pushViewController:VC animated:YES];
            
            //4.关闭侧边栏
            [self.sideMenuViewController hideMenuViewController];
            
            break;
        }
        case 1:
            break;
        default:
            break;
    }
}

@end
