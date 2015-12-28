//
//  AppCell.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarView;
@class AppModel;

@interface AppCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *expireDate;
@property (weak, nonatomic) IBOutlet UILabel *lastPrice;
@property (weak, nonatomic) IBOutlet StarView *startCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *appTimes;

@property (nonatomic, strong) AppModel *model;

@end
