//
//  Item3TableViewController.m
//  SideMenuDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "Item3TableViewController.h"
#import "UIScrollView+Scale.h"

@interface Item3TableViewController ()

@end

@implementation Item3TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self addScaleView];
}

- (void)addScaleView {

    [self.tableView addScaleImageViewWithImage:[UIImage imageNamed:@"image003.jpg"]];
    
    UITableView *table = self.tableView;
}

@end
