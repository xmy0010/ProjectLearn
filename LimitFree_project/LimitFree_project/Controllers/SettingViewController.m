//
//  SettingViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/18.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "CollectionViewController.h"
#import "MySettingViewController.h"

@interface SettingViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *namesArray;
@property (nonatomic, strong) NSArray *picturesArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavigationItem];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellWithReuseIdentifier:@"SettingCell"];
    //设置单元格的大小
    UICollectionViewFlowLayout *flowLaout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLaout.itemSize = CGSizeMake(57, 57 + 30);
    //设置行间隙 以滚动方法判断Line
    flowLaout.minimumLineSpacing = 20;
    //设置单元格间隙
    flowLaout.minimumInteritemSpacing = 40;
    //设置内间距                                 //上 左 下 右
    flowLaout.sectionInset = UIEdgeInsetsMake(35, 30, 30, 35);
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.namesArray = @[@"我的设置", @"我的关注",@"我的账号",@"我的收藏",@"我的下载",@"我的评论",@"我的帮助",@"蚕豆应用"];
    self.picturesArray = @[@"setting", @"favorite", @"user", @"collect", @"download", @"comment",@"help", @"candou"];
    
    //刷新UICollectionView
    [self.collectionView reloadData];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.namesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    //复用Cell
    SettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SettingCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"account_%@", self.picturesArray[indexPath.row]]];
    cell.name.text = self.namesArray[indexPath.row];
    
    return cell;
    
}

//定制导航项
- (void)customNavigationItem {

    [self addNavigationItemTilte:@"设置"];
    [self addBarButtonItemWithTarget:self action:@selector(back:) name:@"返回" isLeft:YES];
    
    UIButton *leftButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];
}

- (void)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3) {
        CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    } else if (indexPath.row == 0) {
    
        //创建UIStoryboard对象
        UIStoryboard *mainS = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //实例化视图控制器
        MySettingViewController *mySettingVC = [mainS instantiateViewControllerWithIdentifier:@"MySettingViewController"];
        [self.navigationController pushViewController:mySettingVC animated:YES];
        
    }
}

@end
