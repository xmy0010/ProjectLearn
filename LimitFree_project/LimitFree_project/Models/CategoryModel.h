//
//  CategoryModel.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface CategoryModel : BaseModel

@property (nonatomic, copy) NSString *categoryCname;

@property (nonatomic, copy) NSString *categoryCount;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *down;

@property (nonatomic, copy) NSString *same;

@property (nonatomic, copy) NSString *limited;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *up;

@property (nonatomic, copy) NSString *free;

@property (nonatomic, copy) NSString *categoryName;

@end
