//
//  RootViewController.m
//  VideoDemo
//
//  Created by T_yun on 16/1/14.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <AFNetworking.h>
#import "VideoModel.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>
#import "PlayViewController.h"


static NSString *api_url = @"http://baobab.wandoujia.com/api/v1/feed";

@interface RootViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RootViewController

- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = @[].mutableCopy;
    }
    
    return _dataArray;
}

/**在这个类创建对象第一次会调用*/
+ (void)load {

    
}
+(void)initialize {
 
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [SVProgressHUD setRingThickness:10];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestData];
    
    //显示大图的高度
    self.featureHeight = 240;
    
    //普通cell的高度
    self.collapsedHeight = 150;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**请求数据*/
- (void)requestData {
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:api_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        NSArray *arr = responseObject[@"dailyList"][0][@"videoList"];
        for (NSDictionary *dict in arr) {
            VideoModel *model = [[VideoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    

}

#pragma mark - RPSlidingDelegate/datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
    
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row {
    
    VideoModel *model = self.dataArray[row];
    
    slidingMenuCell.textLabel.text = model.title;
    slidingMenuCell.detailTextLabel.text = model.desc;
    [slidingMenuCell.backgroundImageView setImageWithURL:[NSURL URLWithString:model.coverForFeed]];

}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    PlayViewController *playVC = [[PlayViewController alloc] init];
//    playVC.model = self.dataArray[indexPath.row];
//    [self presentViewController:playVC animated:YES completion:^{
//        
//        
//    }];
//    
//    
//}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row {

    PlayViewController *playVC = [[PlayViewController alloc] init];
    playVC.model = self.dataArray[row];
    [self presentViewController:playVC animated:YES completion:^{
        
        
    }];

}

@end
