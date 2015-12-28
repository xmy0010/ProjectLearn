//
//  DatabaseManager.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/21.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CollectionTableModel;

@interface DatabaseManager : NSObject

+ (DatabaseManager *)sharedManager;

//插入数据
- (BOOL)insertCollectionTableModel:(CollectionTableModel *)model;

//判断数据库中是否存在数据
- (BOOL)isExistsWithAppId:(NSString *)appId;

- (NSArray *)getAllCollection;

- (void)test;


@end
