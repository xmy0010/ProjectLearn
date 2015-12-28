//
//  DatabaseManager.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/21.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h" //3party lib
#import "CollectionTableModel.h"


@implementation DatabaseManager {

    FMDatabase *_database;
}
//单例

+ (DatabaseManager *)sharedManager {
    
    static DatabaseManager *dataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DatabaseManager alloc] init];
    });
    return dataManager;
}

//重写初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDatabase];
    }
    return self;
}

//初始化数据库
- (void)initDatabase {
    if (_database == nil) {
        //将数据库文件放入沙盒路径下的Documents中
        NSString *databasePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/limitFree.db"];
        //创建数据库管理对象
        _database = [[FMDatabase alloc] initWithPath:databasePath];
        NSLog(@"%@", databasePath);
    }

    //打开数据库
    if ([_database open]) {
     
        //创建数据库表
        //可以先用软件sqbrower调试再拷贝执行语句字符创过来
        [_database executeUpdate:@"create table if not exists collection(appId text primary key, appName text, appImage text);"];
    } else {
        NSLog(@"can't open the database.");
    }
}

#pragma mark - database

//查询数据是否存在
- (BOOL)isExistsWithAppId:(NSString *)appId {
    //从数据库查询对应appId的数据
//    FMResultSet *resultSet = [_database executeQuery:@"select *from collection where appId = '%@'", appId]; //sq语句中需要字符创引号
      FMResultSet *resultSet = [_database executeQuery:@"select *from collection where appId = ?", appId]; //用问号 不然全部返回yes
    //判断查询的数据是否存在
    if ([resultSet next]) {
        return YES;
    } else {
        return NO;
    }
}
//插入数据
- (BOOL)insertCollectionTableModel:(CollectionTableModel *)model {
    //判断是否已有数据
    if ([self isExistsWithAppId:model.appId]) {
        
        //如果存在 就更新该key对应的数据
//        BOOL isSuccess = [_database executeUpdate:@"update collection SET appName = '%@', appImage = '%@' where appId = '%@'", model.appName, model.appImage, model.appId];  拼接的时候参数用?代替
         BOOL isSuccess = [_database executeUpdate:@"update collection SET appName = ?, appImage = ? where appId = ?", model.appName, model.appImage, model.appId];
         return isSuccess;
    } else {
        BOOL isSuccess = [_database executeUpdate:@"insert into collection values(?, ?, ?)", model.appId, model.appName, model.appImage];
        return isSuccess;
    }
    
}

//获取所有的收藏数据
- (NSArray *)getAllCollection {

    NSMutableArray *collectionModels = [NSMutableArray array];
    //获取collection表中所有数据
    FMResultSet *resultSet = [_database executeQuery:@"select *from collection"];
    //遍历结果集
    while ([resultSet next]) {
        //创建模型数据
        CollectionTableModel *model = [[CollectionTableModel alloc] init];
        model.appId = [resultSet stringForColumn:@"appId"];
        model.appName = [resultSet stringForColumn:@"appName"];
        model.appImage = [resultSet stringForColumn:@"appImage"];
        
        [collectionModels addObject:model];
    }
    return [collectionModels copy];
}


- (void)test {

    CollectionTableModel *model = [[CollectionTableModel alloc] init];
    model.appId = @"110";
    model.appName = @"model";
    model.appImage = @"http://image.bb.cn";
    
    NSLog(@"isExists:%d", [self isExistsWithAppId:model.appId]);
    
    NSLog(@"insert:%d", [self insertCollectionTableModel:model]);
}

@end
