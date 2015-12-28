//
//  UIScrollView+Scale.m
//  SideMenuDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "UIScrollView+Scale.h"
#import <objc/runtime.h>

static const NSString *kScaleView = @"kScallView";
static NSString *kContentOffset = @"contentOffset";

#define ScaleViewHeight 200

@implementation ScaleView

- (void)setScrollView:(UIScrollView *)scrollView {

    [_scrollView removeObserver:self forKeyPath:kContentOffset];
    //观察ScrollView的contentOffset的改变
    _scrollView = scrollView;
    //KVO
    [_scrollView addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

//KVO的调用方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    //刷新当前视图的大小
    [self setNeedsLayout]; //注册当前视图需要刷新 在下一个循环的时候就会调用layoutSubviews // NSRunLoop
}

//布局子控件
-(void)layoutSubviews {

    [super layoutSubviews];
    
    //往上拉scrollview的时候 scrollview的偏移为正
    if (_scrollView.contentOffset.y < 0) {
        CGFloat offset = _scrollView.contentOffset.y;
        
        self.frame = CGRectMake(offset, offset, CGRectGetWidth(_scrollView.frame) - offset * 2, ScaleViewHeight - offset);
    } else {
         self.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame) , ScaleViewHeight);
    }
}

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:kContentOffset];
}

//作用于上一个函数相同 保证有时候该视图是被removeFromSuperviwe
- (void) removeFromSuperview {
    
     [_scrollView removeObserver:self forKeyPath:kContentOffset];
}

@end


@implementation UIScrollView (Scale)

- (void)setScaleView:(ScaleView *)scaleView {
    //用runtime 给UIScrollView绑定属性
    objc_setAssociatedObject(self, &scaleView, scaleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ScaleView *)scaleView {
    return objc_getAssociatedObject(self, &kScaleView);
}

- (void)addScaleImageViewWithImage:(UIImage *)image {

    //创建一个ScaleView
    ScaleView *scaleView = [[ScaleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), ScaleViewHeight)];
    scaleView.scrollView = self;
    
    scaleView.image = image;
    [self addSubview:scaleView];
    
    //把scaleView送到self的最底层
    [self sendSubviewToBack:scaleView];
    
    self.scaleView = scaleView;
    
}

- (void)removeScaleImageView {

    [self.scaleView removeFromSuperview];
    self.scaleView = nil; //指向空 释放
}

@end
