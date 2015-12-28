//
//  SubjectAppView.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/16.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "SubjectAppView.h"
#import "StarView.h"
#import "AppModel.h"
#import "UIImageView+WebCache.h"


@implementation SubjectAppView {
    
    UIImageView *_imageView;
    UILabel *_appNameLable;
    UIImageView *_commentImageView;
    UILabel *_commentLable;
    UIImageView *_downloadImageView;
    UILabel *_downloadLable;
    StarView *_starView;
}
//该方法会内部调用下面的俩种（看什么方式创建）
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self createUI];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(AppModel *)model {

    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    _appNameLable.text = model.name;
    _commentLable.text = model.ratingOverall;
    _downloadLable.text = model.downloads;
    [_starView setStarValue:[model.starOverall floatValue]];
}


//创建视图
- (void)createUI {

    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _appNameLable = [[UILabel alloc] init];
    _appNameLable.font = [UIFont systemFontOfSize:14];
    [self addSubview:_appNameLable];
    
    _commentImageView = [[UIImageView alloc] init];
    _commentImageView.image = [UIImage imageNamed:@"topic_Comment"];
    [self addSubview:_commentImageView];
    
    _commentLable = [[UILabel alloc] init];
    [self addSubview:_commentLable];
    _commentLable.font = [UIFont systemFontOfSize:13];
    
    _downloadImageView = [[UIImageView alloc] init];
    [self addSubview:_downloadImageView];
    _downloadImageView.image = [UIImage imageNamed:@"topic_Download"];
    
    _downloadLable = [[UILabel alloc] init];
    [self addSubview:_downloadLable];
    _downloadLable.font = [UIFont systemFontOfSize:13];
    
    _starView = [[StarView alloc] init];
    [self addSubview:_starView];
    
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(3);
        make.top.equalTo(self.mas_top).offset(3);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.width.equalTo(_imageView.mas_height);
    }];
    
    [_appNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(_imageView.mas_right).offset(8);
    }];
    
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_appNameLable.mas_left);
        make.centerY.equalTo(_imageView.mas_centerY);
        make.width.equalTo(@13);
        make.height.equalTo(@13);
    }];
    
    [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentImageView.mas_right).offset(3);
        make.centerY.equalTo(_imageView.mas_centerY);
    }];
    
    [_downloadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(_imageView.mas_centerY);
    }];
    
    [_downloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_downloadLable.mas_left).offset(3);
        make.centerY.equalTo(_imageView.mas_centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@11);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageView.mas_bottom);
        make.left.equalTo(_appNameLable.mas_left);
        make.width.equalTo(@16);
        make.height.equalTo(@5.5);
    }];
}

@end
