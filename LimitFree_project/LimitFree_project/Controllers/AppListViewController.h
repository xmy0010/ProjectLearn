//
//  AppListViewController.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface AppListViewController : BaseViewController

@property (nonatomic, copy) NSString *requestURL;

//搜索关键字
@property (nonatomic, copy) NSString *searchKeyword;

//分裂ID
@property (nonatomic, copy) NSString *cateID;

@end
