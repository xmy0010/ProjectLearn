//
//  ParallaxCell.h
//  ParallaxDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParallaxCell : UITableViewCell

//添加属性 让cell填充数据
@property (nonatomic, copy) NSString *imageName;

//根据tableView 和VC.view 来滑动当前cell总的图片
- (void)scrollImageInTableView:(UITableView *)tableView inView:(UIView *)view;

@end
