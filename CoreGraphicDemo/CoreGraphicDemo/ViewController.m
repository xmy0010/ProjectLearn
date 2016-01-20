//
//  ViewController.m
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "ViewController.h"
#import "ShapeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShapeViewController *shapeVc = [[ShapeViewController alloc] init];
    shapeVc.type = indexPath.row;
    [self.navigationController pushViewController:shapeVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
