//
//  LoginViewController.m
//  XMPP
//
//  Created by 千锋 on 16/1/20.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "LoginViewController.h"
#import <JSAnimatedImagesView.h>
#import "HHXmppManager.h"
#import <XMPPFramework.h>
#import "FriendsListViewController.h"



@interface LoginViewController () <JSAnimatedImagesViewDataSource>
@property (weak, nonatomic) IBOutlet JSAnimatedImagesView *backgroudView;
@property (nonatomic, strong) NSMutableArray *images;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.navigationController.navigationBar.translucent = YES;
    
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.8], NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    self.usernameTF.attributedPlaceholder = str1;
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.8], NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    self.passwordTF.attributedPlaceholder = str2;
    
    
    self.loginButton.layer.cornerRadius = 5.;
    
    self.backgroudView.dataSource = self;
    [self.backgroudView startAnimating];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <JSAnimatedImagesViewDataSource>

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView {

    return self.images.count;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index {

    return self.images[index];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

#pragma mark - Action
- (IBAction)registerButtonPressed:(UIButton *)sender {
    //让前面登录的下线
    //创建一个状态对象
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [[HHXmppManager sharedManager].xmppStream sendElement:offline];
    [[HHXmppManager sharedManager].xmppStream disconnect];
    
    [self performSegueWithIdentifier:@"showRegister" sender:sender];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    if (self.usernameTF.text.length && self.passwordTF.text.length) {
        NSString *user = [NSString stringWithFormat:@"%@@%@", self.usernameTF.text, HostIP];
        HHXmppManager *manager = [HHXmppManager sharedManager];
        
        [manager loginWithUserName:user password:self.passwordTF.text result:^(BOOL isSuccess, NSError *error) {
            
            if (isSuccess) {
                NSLog(@"登录成功");
               
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //跳转到好友列表
                    UIStoryboard *friendSb = [UIStoryboard storyboardWithName:@"FriendList" bundle:nil];
                    FriendsListViewController *friendVC = [friendSb instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
                    
                     [self.navigationController pushViewController:friendVC animated:YES];
                });
               
            } else {
                NSLog(@"登录失败 error = %@", error);
            }
        }];
    }
   
}

@end
