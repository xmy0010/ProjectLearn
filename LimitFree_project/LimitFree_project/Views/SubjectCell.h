//
//  SubjectCell.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/16.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubjectModel;


@interface SubjectCell : UITableViewCell

@property (nonatomic, strong) SubjectModel *model;

@property (weak, nonatomic) IBOutlet UILabel *subjectTitle;
@property (weak, nonatomic) IBOutlet UIImageView *subjectImageView;
@property (weak, nonatomic) IBOutlet UIView *appListView;
@property (weak, nonatomic) IBOutlet UIImageView *descImageView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;


@end
