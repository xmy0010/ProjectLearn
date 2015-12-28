//
//  CategoryViewController.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/15.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//传值的Block
typedef void (^CategoryBlock)(NSString *cateID);

@interface CategoryViewController : BaseViewController

// limit free reduce 
@property (nonatomic, copy) NSString *currentCateType;
@property (nonatomic, copy) CategoryBlock block;

@end
