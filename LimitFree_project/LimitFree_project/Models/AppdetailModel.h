//
//  AppdetailModel.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/17.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photos;
@interface AppdetailModel : NSObject



@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *lastPrice;

@property (nonatomic, copy) NSString *desc; //des

@property (nonatomic, copy) NSString *applicationId;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *itunesUrl;

@property (nonatomic, copy) NSString *ratingOverall;

@property (nonatomic, copy) NSString *releaseDate;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *downloads;

@property (nonatomic, copy) NSString *releaseNotes;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *appurl;

@property (nonatomic, copy) NSString *sellerId;

@property (nonatomic, copy) NSString *sellerName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *starCurrent;

@property (nonatomic, copy) NSString *starOverall;

@property (nonatomic, copy) NSString *priceTrend;

@property (nonatomic, copy) NSString *expireDatetime;

@property (nonatomic, copy) NSString *newversion;

@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *description_long;

@property (nonatomic, copy) NSString *systemRequirements;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *currentVersion;



@end
@interface Photos : NSObject

@property (nonatomic, copy) NSString *smallUrl;

@property (nonatomic, copy) NSString *originalUrl;

@end

