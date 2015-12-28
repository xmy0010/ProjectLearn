//
//  SearchViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self addBarButtonItemWithTarget:self action:@selector(back:) name:@"返回" isLeft:YES];
    //获取左边barButtonItem的自定义view(为一个Button)
    UIButton *leftButton = (UIButton *)[self.navigationItem.leftBarButtonItem customView];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];
    
    //设置标题
    [self addNavigationItemTilte:self.searchKeyword];
}

- (void)back:(UIButton *)sender {
 
    [self.navigationController popToRootViewControllerAnimated:YES];
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
