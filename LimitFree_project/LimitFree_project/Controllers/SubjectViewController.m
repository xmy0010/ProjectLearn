//
//  SubjectViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "SubjectViewController.h"
#import "LimitFressNetworkingManager.h"
#import "SubjectModel.h"
#import "SubjectCell.h"

@interface SubjectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LimitFressNetworkingManager *manager;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage; //当前页数

@end

@implementation SubjectViewController

//惰性加载
- (LimitFressNetworkingManager *)manager {

    if (_manager == nil) {
        _manager = [LimitFressNetworkingManager manager];
    }
    
    return _manager;
}

- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    _currentPage = 1;
    [self requestDataWithPage:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 300;

    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"SubjectCell" bundle:nil] forCellReuseIdentifier:@"SubjectCell"];
}



#pragma mark - About data

- (void)requestDataWithPage:(NSInteger)page {
    
    NSString *requestURL = [NSString stringWithFormat:kSubjectUrl, page];
    [self.manager GET:requestURL parameters:nil success:^(NSData *data, NSURLResponse *response) {
       
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //将数组转换为模型
        for (NSDictionary *subjectDict in responseArray) {
            SubjectModel *model = [[SubjectModel alloc] init];
            [model setValuesForKeysWithDictionary:subjectDict];
            
            NSLog(@"%@", model);
            [self.dataArray addObject:model];
            
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    } failure:^(NSURLResponse *response, NSError *error) {
        
    }];
}

#pragma mark - <UITableViewDatasource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    
    SubjectModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

@end
