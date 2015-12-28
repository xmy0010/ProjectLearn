//
//  UIScrollView+Scale.h
//  SideMenuDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleView : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;

@end


@interface UIScrollView (Scale)

//类别里面不能定义实例变量
@property (nonatomic, weak) ScaleView *scaleView; //weak

//添加可拉伸图片
- (void)addScaleImageViewWithImage:(UIImage *)image;

//移除可拉伸图片
- (void)removeScaleImageView;


@end
