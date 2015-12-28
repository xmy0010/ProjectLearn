//
//  BaseViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavigationItemTilte:(NSString *)title {

    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLable.font = [UIFont systemFontOfSize:20];
    titleLable.textColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    
    //设置UINavigationItem.titleView;
    self.navigationItem.titleView = titleLable;
}

- (void)addBarButtonItemWithTarget:(id)target action:(SEL)selector name:(NSString *)name isLeft:(BOOL)isLeft {

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
//    [button setImage: [UIImage imageNamed:@"buttonbar_action"] forState:UIControlStateNormal];  这样image会挡住title
    [button setBackgroundImage:[UIImage imageNamed:@"buttonbar_action"] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //判断左右侧
    if (isLeft == YES) {
        self.navigationItem.leftBarButtonItem = buttonItem;
    } else {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

@end
