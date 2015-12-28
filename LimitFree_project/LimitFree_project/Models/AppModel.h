//
//  AppModel.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "BaseModel.h"

@interface AppModel : BaseModel

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *itunesUrl;

@property (nonatomic, copy) NSString *lastPrice;

@property (nonatomic, copy) NSString *ratingOverall;

@property (nonatomic, copy) NSString *applicationId;

@property (nonatomic, copy) NSString *favorites;

@property (nonatomic, copy) NSString *ipa;

@property (nonatomic, copy) NSString *releaseNotes;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *downloads;

@property (nonatomic, copy) NSString *releaseDate;

@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *shares;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *starCurrent;

@property (nonatomic, copy) NSString *starOverall;

@property (nonatomic, copy) NSString *priceTrend;

@property (nonatomic, copy) NSString *expireDatetime;

@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *desc; //该属性desciption与系统关键字重合 改为desc


@end
