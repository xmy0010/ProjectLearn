//
//  TabBarViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "TabBarViewController.h"
#import "LimitViewController.h"
#import "ReduceViewController.h"
#import "FreeViewController.h"
#import "SubjectViewController.h"
#import "HotViewController.h"
#import "CategoryViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViewControllers];
    [self customTabBar];
    [self customNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createViewControllers {

    //读取plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Controllers" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    //
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (NSDictionary *dict in plistArray) {
        NSString *title = dict[@"title"];
        NSString *iconName = dict[@"iconName"];
        NSString *className = dict[@"className"];
        
        //创建VC
        //根据类名获取对应的Class     Class是一个结构体指针 指向类对应的Class对象 存储这个类对应的isa指针类名方法列表
/* */   Class class = NSClassFromString(className);
        //通过Class对象创建该Class对应类的对象
        AppListViewController *appListVC = [[class alloc] init];
        
        //将VC放入NavigationC
        UINavigationController *navigationC = [[UINavigationController alloc] initWithRootViewController:appListVC];
        
        //设置导航项
        [appListVC addNavigationItemTilte:title];
//
//        //设置导航的按钮
//        [appListVC addBarButtonItemWithTarget:self action:@selector(onLeftClicked:) name:@"分类" isLeft:YES];
//        [appListVC addBarButtonItemWithTarget:self action:@selector(onRightClicked:) name:@"设置" isLeft:NO]; 修改原码 放到子类listVC中 因为不能传值
        
        //设置TabBarItem 原生imageRenderingMode
        UIImage *normalImage = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_press", iconName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
        
        navigationC.tabBarItem = tabBarItem;
        
        [viewControllers addObject:navigationC];
    }
    self.viewControllers = viewControllers;
}

- (void)customTabBar {

    UITabBar *tabBar = self.tabBar;
    //设置背景图片
/*background*/    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
}

- (void)customNavigationBar {
    
    //获取所有视图控制器
    NSArray *viewControllers = self.viewControllers;
    for (UINavigationController *navigationC in viewControllers) {
        //获取navigationBar
        UINavigationBar *navigationBar = navigationC.navigationBar;
        //设置背景图片
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Actions
//导航项上左侧按钮点击
//- (void)onLeftClicked:(UIButton *)sender {
//    NSArray *types = @[kLimitType, kReduceType, kFreeType, kSubjectType, kHotType];
//    
//    
//    CategoryViewController *categoryVC = [[CategoryViewController alloc] init];
//    //获取当前UITabBarController的视图控制器
//    UINavigationController *currentNavigationC = (UINavigationController *)self.selectedViewController;
//    categoryVC.currentCateType = types[self.selectedIndex];
//    [currentNavigationC pushViewController:categoryVC animated:YES];
//}
//
////导航项右侧按钮点击
//- (void)onRightClicked:(UIButton *)sender {
//    
//}

@end
