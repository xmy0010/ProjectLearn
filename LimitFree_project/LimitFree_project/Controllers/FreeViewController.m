//
//  FreeViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "FreeViewController.h"

@interface FreeViewController ()

@end

@implementation FreeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestURL = kFreeUrl;
    }
    return self;
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
