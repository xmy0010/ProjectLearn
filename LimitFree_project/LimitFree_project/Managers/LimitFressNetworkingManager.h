//
//  LimitFressNetworkingManager.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义请求成功和失败的Block
typedef void (^Success)(NSData *data, NSURLResponse *response);
typedef void (^Failure)(NSURLResponse *response, NSError *error);

@interface LimitFressNetworkingManager : NSObject

//创建对象的类方法 工厂方法
+ (instancetype)manager;

- (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;


@end
