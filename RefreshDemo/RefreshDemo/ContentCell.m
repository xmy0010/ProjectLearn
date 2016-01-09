//
//  ContentCell.m
//  RefreshDemo
//
//  Created by 千锋 on 16/1/9.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "ContentCell.h"
#import "ContentModel.h"

@interface ContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@end


@implementation ContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ContentModel *)model {

    self.titleLable.text = model.title;
    self.timeLable.text = model.ct;
    self.contentLable.text = model.text;
}

@end
