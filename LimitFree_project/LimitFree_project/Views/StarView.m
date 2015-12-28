//
//  StarView.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "StarView.h"

@implementation StarView {

    UIImageView *_backgroundImageView;//背景图
    UIImageView *_forgroundImageView; //前景图
}

//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

//在xib或者storyboard中每个视图设置了Custom Class之后, 创建出来的视图都会调用此方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createViews];
    }
    return self;
}


- (void)createViews {

    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_backgroundImageView];
    _backgroundImageView.image = [UIImage imageNamed:@"StarsBackground"];
    //设置内容模式
    _backgroundImageView.contentMode = UIViewContentModeLeft;
    
    //
    _forgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_forgroundImageView];
    _forgroundImageView.image = [UIImage imageNamed:@"StarsForeground"];
    _forgroundImageView.contentMode = UIViewContentModeLeft;
    //设置裁剪 按边界裁剪
    _forgroundImageView.clipsToBounds = YES;
}


//通过传入的参数确定显示星数[0-5]
- (void)setStarValue:(CGFloat)value {

    _starValue = value;
    
    if (value < 0 || value > 5) {
        return;
    }
    //修改前景图的尺寸
    CGRect rect  = _backgroundImageView.frame;
    rect.size.width = rect.size.width * (value / 5.);
    _forgroundImageView.frame = rect;
    
}

@end
