//
//  SubjectModel.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/16.
//  Copyright (c) 2015年 千锋. All rights reserved.
//
/**
 *  专题模型
 */
#import "SubjectModel.h"
#import "AppModel.h"

@implementation SubjectModel

- (void)setApplications:(NSArray *)applications {

//    if (applications == nil) {
//        return;
//    } //传进来的对象始终不会为空 即使没有数据 也是空数组

    if (applications.count == 0) {
        _applications = applications;
    } else {
        NSMutableArray *appModels = [NSMutableArray array];
        for (NSDictionary *appDict in applications) {
            AppModel *model = [[AppModel alloc] init];
            [model setValuesForKeysWithDictionary:appDict];
            [appModels addObject:model];
        }
        
        //对实例变量进行赋值
        _applications = [appModels copy];
    }
}
    


@end


