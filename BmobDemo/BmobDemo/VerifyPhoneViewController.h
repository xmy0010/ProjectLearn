//
//  VerifyPhoneViewController.h
//  BmobDemo
//
//  Created by 千锋 on 16/1/8.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhoneBlock)();

@interface VerifyPhoneViewController : UIViewController

@property (nonatomic, copy) PhoneBlock phonebindBlock;

@end
