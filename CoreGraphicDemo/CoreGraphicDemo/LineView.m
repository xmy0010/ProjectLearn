//
//  LineView.m
//  CoreGraphicDemo
//
//  Created by HeHui on 16/1/19.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "LineView.h"

@implementation LineView

/**自定义绘画，必须在这个方法中实现，因为在这个方法中才能获得当前的图形上下文*/
- (void)drawRect:(CGRect)rect
{
    // 1. 获取当前图形上下文（画布）
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 2. 设置画笔颜色
    CGContextSetRGBStrokeColor(context, 1, 0, 1, 1);
    // 3. 设置画笔线条的粗细
    CGContextSetLineWidth(context, 5);
    // 4. 让画笔从哪个点开始画（设置起始点）
    CGContextMoveToPoint(context, 50, 100);
    // 5. 画一条线段
    CGPoint endPoint = CGPointMake(300, 100);
    
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextAddLineToPoint(context, 300, 200);
    
    // 6. 实施绘画
    CGContextStrokePath(context);
    
    
    // 再画一条
    
    // 创建一个点的数组
    CGPoint p1 = CGPointMake(50, 250);
    CGPoint p2 = CGPointMake(300, 250);
    CGPoint p3 = CGPointMake(300, 300);
    CGPoint p4 = CGPointMake(50, 300);
    CGPoint points[] = {p1,p2,p3,p4};
    // 添加多条线段
    CGContextAddLines(context, points, sizeof(points)/sizeof(CGPoint));
    // 设置画笔颜色
    [[UIColor orangeColor] setStroke];
    // 设置填充颜色
    [[UIColor cyanColor] setFill];
    // 封闭路径
//    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPoint po1 = CGPointMake(50, 350);
    CGPoint po2 = CGPointMake(300, 370);
    CGPoint po3 = CGPointMake(200, 450);
    CGPoint points2[] = {po1,po2,po3};
    CGContextAddLines(context, points2, 3);
    CGContextSetLineWidth(context, 10);
    [[UIColor brownColor] setStroke];
    // 设置线条端点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // 设置连接点样式
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // 画虚线
    CGContextMoveToPoint(context, 0, 500);
    CGContextAddLineToPoint(context, 350, 500);
    CGContextSetLineWidth(context, 1);
    
    /*
       参数一,当前图形上下文
       参数二,虚线的第一条线段的偏移量
       参数三,虚线 虚实交替的线段长度规则 数组（lengths）
       参数四, lengths的元素个数
     */
    
    CGFloat lengths[] = {10,10};
    
    CGContextSetLineDash(context, 0, lengths, sizeof(lengths)/sizeof(CGFloat));
    [[UIColor blueColor] setStroke];
    CGContextStrokePath(context);
    
    
    
    // 画虚线
    CGContextMoveToPoint(context, 0, 500+20);
    CGContextAddLineToPoint(context, 350, 500+20);
    CGContextSetLineWidth(context, 1);
    
    /*
     参数一,当前图形上下文
     参数二,虚线的第一条线段的偏移量
     参数三,虚线 虚实交替的线段长度规则 数组（lengths）
     参数四, lengths的元素个数
     */
    
    CGFloat lengths2[] = {10,10};
    
    CGContextSetLineDash(context, 3, lengths2, sizeof(lengths2)/sizeof(CGFloat));
    [[UIColor redColor] setStroke];
    CGContextStrokePath(context);

}

@end
