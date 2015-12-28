//
//  AppListViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "AppListViewController.h"
#import "LimitFressNetworkingManager.h"
#import "AppModel.h"
#import "TableFooterView.h"
#import "AppCell.h"
#import "SearchViewController.h"
#import "CategoryViewController.h"
#import "AppDetailViewController.h"
#import "SettingViewController.h"


@interface AppListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {

    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIRefreshControl *_refreshControl; //活动指示器 UITableView.header下拉刷新
    NSInteger _currentPage;  //记录当前请求的页数page
    
    TableFooterView *_tableFooterView; //自定义表尾的视图 上拉加载更多
    
}

@property (nonatomic, strong) LimitFressNetworkingManager *manager;

@end

@implementation AppListViewController


//通过惰性加载方式创建对象（重写属性的getter）
//如果重写了getter方法 只能通过属性访问 不能通过实例变量访问
- (LimitFressNetworkingManager *)manager {

    if (_manager == nil) {
        _manager = [LimitFressNetworkingManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    [self createSearchBar];
    
    _currentPage = 1; //初始化一个值为1
    
    [self firstLoad];
    
    [self customNavigationItem];
    
    
//    //添加观察者 监听分类栏目下单元格被选中的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryChanged:) name:@"CategoryChangedNotification" object:nil]; 代码耦合度高  且需判断工作量大
    
}



- (void)firstLoad {
    
     //让刷新控件启动动画 并且请求数据
    [_refreshControl beginRefreshing];
    [self headerRefresh:_refreshControl];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)customNavigationItem {

    
    //设置导航的按钮
    [self addBarButtonItemWithTarget:self action:@selector(onLeftClicked:) name:@"分类" isLeft:YES];
    [self addBarButtonItemWithTarget:self action:@selector(onRightClicked:) name:@"设置" isLeft:NO];
}

- (void)createTableView {

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置单元格
    _tableView.rowHeight = 140;
    
    //注册单元格 可以从Nib和Class俩种方式 bundle nil表示Main bundle
    //参数一 Nib对象
    //参数二 复用的标志
    [_tableView registerNib:[UINib nibWithNibName:@"AppCell" bundle:nil] forCellReuseIdentifier:@"AppCell"];
    
    //创建活动指示器
    _refreshControl = [[UIRefreshControl alloc] init];
    [_tableView addSubview:_refreshControl];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(headerRefresh:) forControlEvents:UIControlEventValueChanged];

/**/
    //创建上拉加载更多视图
    _tableFooterView = [[TableFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    //设置UITableView的footerView
    _tableView.tableFooterView = _tableFooterView;
   
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestMore:)];
    [_tableFooterView addGestureRecognizer:tapGesture];
}

#pragma mark - Actions

- (void)onLeftClicked:(UIButton *)sender {
    NSArray *types = @[kLimitType, kReduceType, kFreeType, kSubjectType, kHotType];
    
    
    CategoryViewController *categoryVC = [[CategoryViewController alloc] init];
    
    //当被push的时候隐藏tabBar
    categoryVC.hidesBottomBarWhenPushed = YES;
    
    //block实现
    categoryVC.block = ^(NSString *cateID) {
        
        self.cateID = cateID;
//        if ([cateID isEqualToString:@"0"]) {
//            self.cateID = nil;
//        }
        //加载数据
        _currentPage = 1; //当前页数置1
        [self firstLoad];
    };
    
    //获取当前UITabBarController的视图控制器
    categoryVC.currentCateType = types[self.tabBarController.selectedIndex];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

//导航项右侧按钮点击
- (void)onRightClicked:(UIButton *)sender {
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)headerRefresh:(UIRefreshControl *)sender {
    
    _currentPage = 1; //每次刷新 重置currentPage为1
    //请求数据
    [self requestDataOnPage:_currentPage search:self.searchKeyword  categoryID:self.cateID];

}

// 表尾上拉请求更多
- (void)requestMore:(UITapGestureRecognizer *)sender {
    
    if ([_tableFooterView responseToTouch] == YES) {
        //修改当前_tableFooterView的状态
        _tableFooterView.status = RefreshStatusLoading;
        
        [self requestDataOnPage:++_currentPage search:self.searchKeyword categoryID:self.cateID];
    }
    
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //复用单元格 自定义通过注册方式关联的cell 下列方法进行复用时 系统会在需要的时候自动创建cell
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];
    
    
    //读取对应的AppModel
    AppModel *model = _dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
//单元格点击回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    AppModel *model = _dataArray[indexPath.row];
    //创建应用详情视图控制器
    AppDetailViewController *appDetailVC = [[AppDetailViewController alloc] init];
    appDetailVC.applicationID = model.applicationId;
    
    [self.navigationController pushViewController:appDetailVC animated:YES];
    
}


#pragma mark - Data
//请求数据
- (void)requestDataOnPage:(NSInteger)page search:(NSString *)search categoryID:(NSString *)cateID {
    //...
//    NSString *url = [NSString stringWithFormat: _requestURL, page, search];
//    //这样后面为空回拼接成这样 无法请求数据http://www.1000phone.net:8088/app/iAppFree/api/limited.php?page=1&number=20&search=(null)
    
    NSString *url = [NSString stringWithFormat:self.requestURL, page, search ? search : @""];//这样如果为空 把“(null)”替换为“”
//    NSLog(@"%@,%@", self.requestURL, url);
//    //http://www.1000phone.net:8088/app/iAppFree/api/limited.php?page=%d&number=20&search=%@,http://www.1000phone.net:8088/app/iAppFree/api/limited.php?page=1&number=20&search=%@ self.requestURL字符串中的%d %@替换为后俩个参数
    
    //对url进行编码  特别是中文的非ASCII码字符需要此设置
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //判断分类是否设置
    if (cateID.length != 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&cate_id=%@", cateID]];
    }
    
    [self.manager GET:url parameters:nil success:^(NSData *data, NSURLResponse *response) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //读取所有的Appcations
        NSArray *applications = responseDict[@"applications"];
        //判断数据源是否为空
        if (_dataArray == nil) {
            _dataArray = [NSMutableArray array];
        }
        
        //当请求的页数为1时 需要将所有的数据清空 之后添加 保持实时更新
        if (_currentPage == 1) {
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *appDict in applications) {
            //将字典转换为模型
            AppModel *model = [[AppModel alloc] init];
            [model setValuesForKeysWithDictionary:appDict];
            
            [_dataArray addObject:model];
        }
        
        //主线程刷新UITableView
        dispatch_async(dispatch_get_main_queue(), ^{
            //停止活动指示器
            [_refreshControl endRefreshing];
            [_tableView reloadData];
            
            //更新TableFooterView的状态
            _tableFooterView.status = RefreshStatusMore;
        });
        
    } failure:^(NSURLResponse *response, NSError *error) {
        
        //判断当前页数
        if (_currentPage == 1) {
            //表头下拉的请求
            [_refreshControl endRefreshing];
        } else {
            //表尾上拉的请求 当前请求的时候++过 没请求到数据 固当前页--回去
            _currentPage--;
            _tableFooterView.status = RefreshStatusFailure;
        }
        
        NSLog(@"%@", error.localizedDescription);
    }];
    
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        //上拉超出一定值 加载数据+
        [self requestMore:nil];
    }
}

#pragma mark - About Search
- (void)createSearchBar {

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //将UISearchBar添加到UITableView的表头
    _tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    searchBar.placeholder = @"search";
    
    //显示取消按钮
    searchBar.showsCancelButton = YES;
}
#pragma mark - <UISearchBarDelegate>
//点击cancle按钮回调的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //清空输入框的内容 收起键盘
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    
}

//点击键盘上搜索时回调 跳转到搜索结果的界面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.requestURL = self.requestURL;
    searchVC.searchKeyword = searchBar.text;
    searchVC.cateID = self.cateID;
    
    [self.navigationController pushViewController:searchVC animated:YES];
}


@end
