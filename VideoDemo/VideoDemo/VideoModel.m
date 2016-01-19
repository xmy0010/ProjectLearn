//
//  VideoModel.m
//  VideoDemo
//
//  Created by T_yun on 16/1/14.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
}

@end
