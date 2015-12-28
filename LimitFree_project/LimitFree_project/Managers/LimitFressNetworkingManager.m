//
//  LimitFressNetworkingManager.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/14.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "LimitFressNetworkingManager.h"



@implementation LimitFressNetworkingManager {

    NSURLSession *_urlSession;
//    Success _success;   //Block本身就是相当于一个指针 故前面不加*
//    Failure _failure;     每次调用方法会重新给成员变量赋值 固不要
}

+ (instancetype)manager {

    LimitFressNetworkingManager *manager = [[LimitFressNetworkingManager alloc] init];
    
    return manager;
}

//重写init
- (instancetype)init
{
    self = [super init];
    if (self) {
        //进行session的配置 默认配置
        _urlSession = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

//请求数据
- (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
//    _success = success;  //对成员变量Block进行赋值
//    _failure = failure;  不要了
    
    //拼接请求地址
    NSMutableString *mutableString = [NSMutableString stringWithString:url];
    
    //判断存在paramers
    if (parameters != nil) {
        NSMutableArray *parametersArray = [NSMutableArray array];
        //遍历字典             //paramters.allKeys
        for (NSString *key in parameters) {
            NSString *param = [NSString stringWithFormat:@"%@=%@", key, parameters[key]];
            [parametersArray addObject:param];
        }
        //将数组转换为每个元素之间隔一个‘&’的字符串
        NSString *paramsString = [parametersArray componentsJoinedByString:@"&"];
        [mutableString appendFormat:@"?%@", paramsString];
    }
    
    //创建Requset
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mutableString]];
    
    //通过NSUrlSession请求数据
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //判断是否请求成功
        if (error == nil) {
            if (success) {
                success(data, response);
            }
        } else {
            if (failure) {
                failure(response, error);
            }
        }
    }];

    [dataTask resume];
}


@end
