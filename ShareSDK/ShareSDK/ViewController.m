//
//  ViewController.m
//  ShareSDK
//
//  Created by T_yun on 16/1/11.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareButtonPressed:(UIButton *)sender {
    
    NSArray *images = @[[UIImage imageNamed:@"Default1"],
                        [UIImage imageNamed:@"Default2"]];
    if (images) {
        NSMutableDictionary *prams = @{}.mutableCopy;
        //创建分享参数
        [prams SSDKSetupShareParamsByText:@"This is a test"
                                   images:images
                                      url:[NSURL URLWithString:@"http://baidu.com"]
                                    title:@"test Title"
                                     type:SSDKContentTypeAuto];
        
        [ShareSDK showShareActionSheet:self.view
                                 items:nil
                           shareParams:prams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                               NSLog(@"分享成功");
                               break;
                               
                           case SSDKResponseStateFail:
                               NSLog(@"分享失败");
                               break;
                               
                           case SSDKResponseStateCancel:
                               NSLog(@"分享取消");
                               break;
                               
                           default:
                               break;
                       }
                   }];
    }
}

@end
