//
//  MySettingViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/22.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "MySettingViewController.h"
#import "SDImageCache.h"

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


//清除缓存
- (void)clearWebCache {
    //缓存的文件个数
    NSUInteger diskCount = [[SDImageCache sharedImageCache] getDiskCount];
   
    //缓存的大小
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize] ;
    
    
    NSString *message = [NSString stringWithFormat:@"缓存文件数量:%ld, 缓存文件大小:%ldM", diskCount, cacheSize / 1024 / 1024];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"clearCache" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加action
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancle];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"clear" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
    }];
    [alertController addAction:clearAction];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row) {
        [self clearWebCache];
    }
}

@end
