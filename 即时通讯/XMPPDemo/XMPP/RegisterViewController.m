//
//  RegisterViewController.m
//  XMPP
//
//  Created by 千锋 on 16/1/20.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "RegisterViewController.h"
#import <JSAnimatedImagesView.h>
#import "HHXmppManager.h"

@interface RegisterViewController () <JSAnimatedImagesViewDataSource>
@property (strong, nonatomic) IBOutlet JSAnimatedImagesView *backgroudView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation RegisterViewController


- (NSMutableArray *)images {
    
    if (_images == nil) {
        _images = @[].mutableCopy;
        
        for (int i = 0; i < 3; i++) {
            NSString *imageName = [NSString stringWithFormat:@"bg%d.jpg", i + 1];
            UIImage *image = [UIImage imageNamed:imageName];
            [_images addObject:image];
        }
    }
    
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroudView.dataSource = self;
    [self.backgroudView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action

- (IBAction)registerButtonPressed:(UIButton *)sender {
    
    if (self.usernameTF.text.length && self.passwordTF.text.length) {
        NSString *username = [NSString stringWithFormat:@"%@@%@", self.usernameTF.text, HostIP];
       
        //开始注册
        [[HHXmppManager sharedManager] registerWithUsername:username password:self.passwordTF.text result:^(BOOL isSuccess, NSError *error) {
            
            if (isSuccess) {
                
                NSLog(@"注册成功");
                //主线程操作挑战 目前在添加的后台队列
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                });
               
            } else {
                NSLog(@"注册失败error=%@", error);
            }
        }];
    }
}

#pragma mark <JSAnimatedImagesViewDataSource>

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView {
    
    return self.images.count;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index {
    
    return self.images[index];
}


@end
