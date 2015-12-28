//
//  SubjectCell.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/16.
//  Copyright (c) 2015年 千锋. All rights reserved.
//
#import "SubjectModel.h"
#import "SubjectCell.h"
#import "UIImageView+WebCache.h"
#import "SubjectAppView.h"
#import "AppModel.h"


@implementation SubjectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SubjectModel *)model {

    _model = model;
    self.subjectTitle.text = model.title;
    [self.subjectImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"topic_TopicImage_Default"]];
    //设置描述图片
    [self.descImageView sd_setImageWithURL:[NSURL URLWithString:model.desc_img] placeholderImage:[UIImage imageNamed: @"topic_Header"]];
    //设置描述文本
    self.descTextView.text = model.desc;
    //设置专题中应用信息
    
    UIView *preView = nil; //记录上一个已经创建的视图
    for (AppModel *appModel in _model.applications) {
        SubjectAppView *subAppView = [[SubjectAppView alloc] init];
        [self.appListView addSubview:subAppView];
        subAppView.model = appModel;
        
        [subAppView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.appListView.mas_left);
            make.right.equalTo(self.appListView.mas_right);
            make.height.equalTo(self.appListView.mas_height).multipliedBy(1 / 4.);
            if (!preView) {
                make.top.equalTo(self.appListView.mas_top);
            } else {
                make.top.equalTo(preView.mas_bottom);
            }
        }];
         preView = subAppView;
    }
    
}

@end
