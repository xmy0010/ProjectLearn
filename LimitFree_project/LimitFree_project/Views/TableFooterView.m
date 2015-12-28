//
//  TableFooterView.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "TableFooterView.h"

@implementation TableFooterView {

    UIActivityIndicatorView *_indicatorView; // 活动指示器
    UILabel *_textLable;
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

//重写status的setter方法
- (void)setStatus:(RefreshStatus)status {
    
    _status = status;
    
    NSArray *textArray = @[@"", @"", @"加载失败", @"加载更多", @"没有更多"];
    _textLable.text = textArray[_status]; //根据枚举值的NSUInter属性 作为下标对应不同的标题 放弃loading状态的文字显示 只显示活动指示器
    if (status == RefreshStatusLoading) {
        _indicatorView.hidden = NO;
        [_indicatorView startAnimating];
    } else {
        _indicatorView.hidden = YES;
        [_indicatorView stopAnimating];
    }
}


//创建视图
- (void)createViews {

    _textLable = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_textLable];
    _textLable.textAlignment = NSTextAlignmentCenter;  // --
    _textLable.font = [UIFont systemFontOfSize:14];
//    _textLable.backgroundColor = [UIColor redColor];测试用
    
    //关闭停靠模式
    _textLable.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);//edges边缘 边缘全部一样
    }];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];//灰色的
    [self addSubview:_indicatorView];
//    [_indicatorView startAnimating];//测试用  flag该句在 hidden无用
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.center);//居中
        make.center.equalTo(_textLable);
    }];
    
    //一开始隐藏
    _indicatorView.hidden = YES;

}

- (BOOL)responseToTouch {

    BOOL isTouch = self.status == RefreshStatusMore || self.status == RefreshStatusFailure; // 状态值满足俩者任一 isTouch为Yes
    
    return isTouch;
}

@end
