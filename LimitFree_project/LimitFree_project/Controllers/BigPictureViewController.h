//
//  BigPictureViewController.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/18.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPictureViewController : UIViewController


//所有照片和当前选中图片位置
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
