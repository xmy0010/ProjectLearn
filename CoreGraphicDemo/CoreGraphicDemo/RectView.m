//
//  RectView.m
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "RectView.h"

@implementation RectView

- (void)drawRect:(CGRect)srect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(100, 100, 200, 300);
    
    // 添加矩形
    CGContextAddRect(context, rect);
    
    // 添加椭圆
    CGContextAddEllipseInRect(context, rect);

    
    CGContextDrawPath(context, kCGPathStroke);
    
    
    
}

@end
