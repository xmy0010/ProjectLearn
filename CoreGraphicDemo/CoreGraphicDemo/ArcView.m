//
//  ArcView.m
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "ArcView.h"

@implementation ArcView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat startX = 150;
    CGFloat startY = 100;
    CGFloat wh = 100;
    
    CGPoint p1 = CGPointMake(startX, startY);
    CGPoint p2 = CGPointMake(startX + wh, startY);
    CGPoint p3 = CGPointMake(startX + wh, startY + wh + 100);
    CGContextMoveToPoint(context, p1.x, p1.y);
    
    // 绘画弧
    /*
      参数一: 当前图形上下文
      参数(x1,y1): 控制点x,y
      参数(x2,y2): 结束点x,y
      参数 radius: 半径
     */
    
    CGFloat radius = 100;
    
    CGContextAddArcToPoint(context, p2.x, p2.y, p3.x, p3.y, radius);
    [[UIColor redColor] setStroke];
    CGContextStrokePath(context);
    
    
    // 添加两根连线
    CGPoint points[] = {p1,p2,p3};
    CGContextAddLines(context, points, sizeof(points)/sizeof(CGPoint));
    [[UIColor blueColor] setStroke];
    CGContextStrokePath(context);
    
    // 保存上一次使用的样式(包括画笔，填充颜色，等等)
    CGContextSaveGState(context);
    
    
    // 添加两条延长辅助线 p2->p1,p2->p3.
    CGContextMoveToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, 0, p1.y);
    
    CGContextMoveToPoint(context, p3.x, p3.y);
    CGContextAddLineToPoint(context, p3.x, p3.y + 200);
    
    [[UIColor darkGrayColor] setStroke];
    CGFloat lengths[] = {5,5};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    // 画一个圆
    /*
      x,y是圆心的x,y
      radius 半径
      startAngle
     */
    CGContextAddArc(context, p1.x - (radius - wh), p1.y + radius, radius, 0, M_PI * 2, 1);
    [[UIColor greenColor] setStroke];
    [[UIColor lightGrayColor] setFill];
    CGContextDrawPath(context, kCGPathStroke);
    
    // 半圆
    
    // 回复上一次保存的绘图样式
    CGContextRestoreGState(context);
    CGContextAddArc(context, 250, 350, 80, 0, M_PI * 1, 0);
    [[UIColor orangeColor] setStroke];
//    [[UIColor magentaColor] setFill];
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
