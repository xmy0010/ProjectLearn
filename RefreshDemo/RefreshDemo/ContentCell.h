//
//  ContentCell.h
//  RefreshDemo
//
//  Created by 千锋 on 16/1/9.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;

@interface ContentCell : UITableViewCell

@property (nonatomic, strong) ContentModel *model;

@end