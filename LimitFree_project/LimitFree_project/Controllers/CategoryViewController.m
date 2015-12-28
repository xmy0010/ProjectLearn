//
//  CategoryViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryModel.h"
#import "LimitFressNetworkingManager.h"
#import "UIImageView+WebCache.h"

@interface CategoryViewController () < UITableViewDelegate, UITableViewDataSource> {
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) LimitFressNetworkingManager *netManager;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *typeName;    //TabBar英文type转中文
@property (nonatomic, strong) NSString *categoryKey;  //记录分类列表中对应名称

@end

@implementation CategoryViewController

//重写currentCateType
- (void)setCurrentCateType:(NSString *)currentCateType {
    
    _currentCateType = currentCateType;
//    if ([_currentCateType isEqualToString:kLimitType]) {
//        self.typeName = @"限免";
//    } 要写四个if判断
    NSArray *types = @[kLimitType, kReduceType, kFreeType, kHotType];
    NSArray *typeNames = @[@"限免", @"降价", @"免费", @"热榜"];// 俩个数组匹配可以用字典
    NSArray *cateKeys = @[@"limited", @"down", @"free", @"up"];
    
    NSDictionary *typeDict = [NSMutableDictionary dictionaryWithObjects:typeNames forKeys:types];
    NSDictionary *keyDict = [NSDictionary dictionaryWithObjects:cateKeys forKeys:types];
    
    self.typeName = typeDict[_currentCateType];
    self.categoryKey = keyDict[_currentCateType];
}

//惰性加载
- (NSArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (LimitFressNetworkingManager *)netManager {

    if (_netManager == nil) {
        _netManager = [LimitFressNetworkingManager manager];
    }
    return _netManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self addBarButtonItemWithTarget:self action:@selector(back:) name:@"返回" isLeft:YES];
    //获取左边barButtonItem的自定义view(为一个Button)
    UIButton *leftButton = (UIButton *)[self.navigationItem.leftBarButtonItem customView];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];

    
    //设置title
    [self addNavigationItemTilte:self.typeName];
    
    [self createTableView];
    
    //请求数据
    [self requestCategoryData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    
}

- (void)back:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - <UITableViewDatasource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    //读取对应的模型
    CategoryModel *model = _dataArray[indexPath.row];
    //设置图片 网络加载
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"category_All.jpg"]];//jpg格式不加后缀不显示
    cell.textLabel.text = model.categoryCname;
    //根据不同类型设置不同的文字
    NSString *subTitle = [NSString stringWithFormat:@"共%@款应用,其中%@%@款", model.categoryCount, self.typeName, [model valueForKey:self.categoryKey]];
    cell.detailTextLabel.text = subTitle;
    
    return cell;
}

#pragma mark - About data
//请求所有的分类数据
- (void)requestCategoryData {

    [self.netManager GET:kCateUrl parameters:nil success:^(NSData *data, NSURLResponse *response) {
        
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       //遍历数组
        for (NSDictionary *cateDict in responseArray) {
            CategoryModel *model = [[CategoryModel alloc] init];
            //KVC赋值
            [model setValuesForKeysWithDictionary:cateDict];
            
            [self.dataArray addObject:model];
        }
        
        //回到主队列中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //here...
            
            [self.tableView reloadData];
        });
    } failure:^(NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CategoryModel *model = self.dataArray[indexPath.row];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryChangedNotification" object:nil userInfo:nil];
    
    //判断当前block是否存在
    if (self.block) {
        if ([model.categoryId isEqualToString:@"0"]) {
            self.block(nil);
        } else {
            self.block(model.categoryId);
        }
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
