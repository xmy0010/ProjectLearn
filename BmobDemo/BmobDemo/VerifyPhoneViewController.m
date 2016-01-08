//
//  VerifyPhoneViewController.m
//  BmobDemo
//
//  Created by 千锋 on 16/1/8.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "MyButton.h"

@interface VerifyPhoneViewController () {

    NSLock *_lock;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet MyButton *getCodeButton;
@property (weak, nonatomic) IBOutlet MyButton *verifyButton;

@property (nonatomic, copy) NSString  *verifiedPhoneNumber;

@end

@implementation VerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg06"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getCodeButtonPressed:(MyButton *)sender {
    [_lock lock];
    
    if (self.phoneNumberTF.text.length == 0) {
        return;
    }
    
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumberTF.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        if (error == nil) {
            self.verifiedPhoneNumber = self.phoneNumberTF.text;
            [SVProgressHUD showSuccessWithStatus:@"短信已发，请注意查收"];
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
    
    [_lock unlock];
}
- (IBAction)verifyButtonPressed:(MyButton *)sender {
    
    if (self.codeTF.text.length == 0) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"验证手机号..."];
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.verifiedPhoneNumber  andSMSCode:self.codeTF.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
           
            //绑定我的用户
            BmobUser *bUser = [BmobUser getCurrentUser];
            bUser.mobilePhoneNumber = self.verifiedPhoneNumber;
            [bUser setObject:@(YES) forKey:@"mobilePhoneNumberVerified"];
            
            //更新用户
            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *err) {
               
                if (isSuccessful) {
                    [SVProgressHUD showSuccessWithStatus:@"手机号绑定成功"];
                    if (_phonebindBlock) {
                        _phonebindBlock();
                    }
                } else {
                   
                    [SVProgressHUD showErrorWithStatus:err.localizedDescription];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
