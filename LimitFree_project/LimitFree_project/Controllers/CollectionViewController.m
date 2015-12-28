//
//  CollectionViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/21.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "CollectionViewController.h"
#import "DatabaseManager.h"
#import "SettingCell.h"
#import "CollectionTableModel.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"

//删除按钮开始的标记值
#define DELETE_BUTTON_BEGIN_TAG 100


@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isEditing;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavigationItem];
    
    [self createUI];
    
   
    __weak typeof(self) weakSelf = self;
    
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       weakSelf.dataArray = [NSMutableArray arrayWithArray:[[DatabaseManager sharedManager] getAllCollection]];
       //主队列中刷新UI
       dispatch_async(dispatch_get_main_queue(), ^{
           //重新加载数据
           [weakSelf.collectionView reloadData];
       });
      
   });
  
}

//
- (void)customNavigationItem {

    //设置标题
    [self addNavigationItemTilte:@"我的收藏"];
    [self addBarButtonItemWithTarget:self action:@selector(back:) name:@"返回" isLeft:YES];
    [self addBarButtonItemWithTarget:self action:@selector(onEdit:) name:@"编辑" isLeft:NO];
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


//创建视图
- (void)createUI {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    //设置间距
    flowLayout.itemSize = CGSizeMake(67, 67 + 30);
    //设置行间隙 以滚动方法判断Line
    flowLayout.minimumLineSpacing = 15;
    //设置单元格间隙
    flowLayout.minimumInteritemSpacing = 30;
    //设置内间距                                 //上 左 下 右
    flowLayout.sectionInset = UIEdgeInsetsMake(35, 30, 30, 35);

    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    
    //注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    //flag  identifier的作用域是该class?还是该app

}

#pragma  mark - Action
- (void)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onEdit:(UIButton *)sender {
    
    if (self.isEditing == YES) {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.isEditing = NO;
        
    } else {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.isEditing = YES;
    }
    //重新刷新UICollectionView 显示或者隐藏删除按钮以及动画效果
    [_collectionView reloadData];
}

- (void)deleteButtonClicked:(UIButton *)sender {
    //获取点击删除按钮对应的单元格位置
    NSInteger selectedIndex = sender.tag - DELETE_BUTTON_BEGIN_TAG;
    
    
    //找到按钮对应的单元格视图
    CollectionViewCell *superCell = (CollectionViewCell *)sender.superview.superview;
    //找到单元格在collectionView中的位置
    NSIndexPath *indexPath = [_collectionView indexPathForCell:superCell];
    //先删数据再删UI
    //删除之后需要重新计算删除按钮的tag值
    //且需要延迟执行刷新
    //参数一为延迟执行的时间
    //dispatch_time(<#dispatch_time_t when#>, <#int64_t delta#>) 参数为时间， delta为纳秒级之后   一秒为NSEC_PER_SEC纳秒
    //参数二为执行的队列
    //参数三为执行的Block
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.35 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
    
}

#pragma mark - <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    //取出对应的模型
    CollectionTableModel *model = _dataArray[indexPath.row];
    [cell.appImageView sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    cell.appName.text = model.appName;
    
    
    //判断当前是否处于编辑状态
    if (self.isEditing) {
        cell.deleteButton.hidden = NO;
        //抖动的动画
        CGAffineTransformMakeRotation(-0.05);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.transform = CGAffineTransformMakeRotation(0.05);
                         } completion:nil];
        //UIViewAnimationOptionAllowUserInteraction该句必须加上 不然不能点击Button
    } else {
        cell.deleteButton.hidden = YES;
        //恢复原状 取消动画
        cell.transform = CGAffineTransformIdentity;
    }
    
    //给deleteButton添加target
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //设置tag值
    cell.tag = DELETE_BUTTON_BEGIN_TAG + indexPath.row;
    
    
    return cell;
    
}

@end
