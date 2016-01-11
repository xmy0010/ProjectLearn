//
//  MyNavigationController.m
//  StausBarStyleDemo
//
//  Created by 千锋 on 16/1/9.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
}


//- (UIViewController *)childViewControllerForStatusBarHidden {
//    
////    UIViewController *vc = self.viewControllers.lastObject;
//    
//    return self.topViewController;//当前显示的为top
//}

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
