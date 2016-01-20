//
//  ShapeViewController.h
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShapeType) {
    ShapeTypeLine,  // 线 
    ShapeTypeArc    // 弧
};

@interface ShapeViewController : UIViewController

/** 图形类型 */
@property (nonatomic, assign) ShapeType type;


@end
