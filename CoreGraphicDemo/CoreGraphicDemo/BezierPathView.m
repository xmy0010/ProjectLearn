//
//  BezierPathView.m
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 添加二次贝塞尔曲线
    CGContextMoveToPoint(context, 50, 100);
    
    CGContextAddQuadCurveToPoint(context, 150, 100, 150, 200+100);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    
    // 添加一般贝塞尔曲线
    
    CGContextMoveToPoint(context, 50, 250);
    
    CGContextAddCurveToPoint(context, 60, 150, 200, 200, 350, 450);
    
    [[UIColor purpleColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
}

@end
