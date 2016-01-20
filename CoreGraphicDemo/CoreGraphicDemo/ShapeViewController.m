//
//  ShapeViewController.m
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "ShapeViewController.h"
#import "ArcView.h"
#import "LineView.h"

@interface ShapeViewController ()

@end

@implementation ShapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *shapeName = @[@"LineView",
                           @"ArcView",
                           @"RectView",
                           @"BezierPathView"];
    
    NSString *className = shapeName[self.type];
    
    Class class = NSClassFromString(className);
    
    BaseView *baseView = [[class alloc] init];
    baseView.frame = self.view.bounds;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];

    
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
