//
//  ViewController.m
//  RefreshDemo
//
//  Created by 千锋 on 16/1/9.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import "ContentModel.h"
#import <MJRefresh.h>
#import "ContentCell.h"

#define API_URL @"http://apis.baidu.com/showapi_open_bus/showapi_joke/joke_text"

#define API_KEY @"6f5d57f454e217bc78881033a2d968a0"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
/**记录下下拉刷新的一个临时page*/
@property (nonatomic, assign) NSInteger tempPage;

@end

@implementation ViewController


- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = @[].mutableCopy;
    }
    
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //打印系统带的字体
//    NSLog(@"font=%@", [UIFont familyNames]);
    
    _currentPage = 1;
    self.tableView.estimatedRowHeight = 200;//估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    [self requestData];
    
    [self setupRefresh];
    
    //进入界面就刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
 
    
//    /** 刷新控件的状态 */
//    typedef NS_ENUM(NSInteger, MJRefreshState) {
//        /** 普通闲置状态 */
//        MJRefreshStateIdle = 1,
//        /** 松开就可以进行刷新的状态 */
//        MJRefreshStatePulling,
//        /** 正在刷新中的状态 */
//        MJRefreshStateRefreshing,
//        /** 即将刷新的状态 */
//        MJRefreshStateWillRefresh,
//        /** 所有数据加载完毕，没有更多的数据了 */
//        MJRefreshStateNoMoreData
//    };
    
    __weak typeof(self) weakSelf = self;
    //添加下拉刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        //1.将currentPage变为1 刷新首页的数据
        _currentPage = 1;
        //2.重新请求数据
        [weakSelf requestData];
    }];
    
    self.tableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       //1.首先记录下当前下拉之前的page
        _tempPage = _currentPage;
        
        //2.让currentPage自增 请求后面的数据
        _currentPage++;
        
        //3.请求数据
        [weakSelf requestData];
    }];
    self.tableView.mj_footer = refreshFooter;
    //关闭自动刷新
    refreshFooter.automaticallyRefresh = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
 
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求Header参数
    [sessionManager.requestSerializer setValue: API_KEY forHTTPHeaderField:@"apikey"];
    //可接收的返回值类型
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plan",@"text/html",nil];

    
    [sessionManager GET:API_URL parameters:@{@"page" : @(_currentPage)} success:^(NSURLSessionDataTask * dataTask, id response) {
//        NSLog(@"response=%@", response);
        if (self.dataArray.count > 0 && _currentPage == 1) {
            
            [self.dataArray removeAllObjects];
        }
        
        NSArray *contentList = response[@"showapi_res_body"][@"contentlist"];
        for (NSDictionary *dict in contentList) {
            
            ContentModel *model = [ContentModel yy_modelWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //停止刷新
            if (_currentPage == 1) {
                
                [self.tableView.mj_header endRefreshing];
            } else {
                
                [self.tableView.mj_footer endRefreshing];
            }
            
            
            [self.tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * dataTask, NSError * error) {
        
        //停止刷新
        if (_currentPage == 1) {
            
            _currentPage = _tempPage; //不写这句在第三页 上拉失败之后 currentPage仍然变为1 再上拉 变为2  理论应请求的是3
            [self.tableView.mj_header endRefreshing];
        } else {
            
            //失败的时候currentPage并没有增加
            [self.tableView.mj_footer endRefreshing];
            _currentPage--;
        }
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *cellID = @"CellID";
    
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    ContentModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}


@end
