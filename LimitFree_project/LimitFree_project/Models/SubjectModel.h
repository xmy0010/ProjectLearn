//
//  SubjectModel.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/16.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "BaseModel.h"


@interface SubjectModel : BaseModel


@property (nonatomic, strong) NSArray *applications;

@property (nonatomic, copy) NSString *desc_img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *date;


@end

