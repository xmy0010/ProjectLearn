//
//  AppModel.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

//覆盖父类的方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
}



@end
