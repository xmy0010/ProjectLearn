//
//  TableFooterView.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RefreshStatus) {
    RefreshStatusNotVisiable = 0, //不可见隐藏
    RefreshStatusLoading,         //加载中...
    RefreshStatusFailure,         //加载失败
    RefreshStatusMore,            //加载更多
    RefreshStatusNotMore         //没有更多数据了
};

@interface TableFooterView : UIView

@property (nonatomic, assign) RefreshStatus status;

//是否能够响应点击
- (BOOL)responseToTouch;

@end
