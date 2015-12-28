//
//  BaseViewController.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//设置导航项上的title
- (void)addNavigationItemTilte:(NSString *)title;

//设值导航项上的UIBarButtonItem
- (void)addBarButtonItemWithTarget:(id)target action:(SEL)selector name:(NSString *)name isLeft:(BOOL)isLeft;

@end
