//
//  AppCell.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "AppCell.h"
#import "StarView.h"
#import "AppModel.h"
#import "UIImageView+WebCache.h"

@implementation AppCell

//从Nib文件中awake
- (void)awakeFromNib {
    // Initialization code
    //设置图片圆角
    self.appImageView.layer.cornerRadius = 40;
    self.appImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//重写model属性的setter
- (void)setModel:(AppModel *)model {

    _model = model;
    
    //设置UI相关
    [self.appImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    self.appName.text = model.name;
    self.expireDate.text = model.expireDatetime;
    
/**/    //创建多种样式的文本
    NSAttributedString *lastPriceAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.lastPrice] attributes: @{NSStrikethroughStyleAttributeName : @2,NSStrikethroughColorAttributeName : [UIColor redColor]}];
    self.lastPrice.attributedText = lastPriceAttr;
    
    //设置星标
    self.startCurrentView.starValue = model.starCurrent.floatValue;
    
    //设置分类
    self.categoryName.text = model.categoryName;
    
    //设置拼接各种次数
    NSString *appTimesString = [NSString stringWithFormat:@"分享:%@次  收藏:%@次  下载:%@次", model.shares, model.favorites, model.downloads];
    self.appTimes.text = appTimesString;
}

@end
