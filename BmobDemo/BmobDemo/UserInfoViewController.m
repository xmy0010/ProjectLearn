//
//  UserInfoViewController.m
//  BmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 千锋. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MyImageView.h"
#import "MyButton.h"
#import <BmobSDK/BmobProFile.h>

typedef NS_ENUM(NSInteger, ChosePhotoType) {

    ChosePhotoTypeAlbum,
    ChosePhotoTypeCamera
};

@interface UserInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet MyImageView *userIcon;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)userIconTapAction:(UITapGestureRecognizer *)sender {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择相片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self chosePhoto: ChosePhotoTypeAlbum];
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chosePhoto:ChosePhotoTypeCamera];
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertC addAction:album];
    [alertC addAction:camera];
    [alertC addAction:cancle];
    
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    
}

- (void)chosePhoto:(ChosePhotoType)type {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (type == ChosePhotoTypeAlbum) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (type == ChosePhotoTypeCamera) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"相机不可用"];
            return;
        }
    }
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (IBAction)logoutButtonPressed:(MyButton *)sender {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"sure to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *quit = [UIAlertAction actionWithTitle:@"quit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [BmobUser logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:User_Refresh_Notice object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [alertC addAction:cancle];
    [alertC addAction:quit];
    [self presentViewController:alertC animated:YES completion:nil];
    
}



#pragma mark - 选中相片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self uploadImageWithImage:image];
    }];
}

/**上传文件到Bmob服务器*/
- (void)uploadImageWithImage:(UIImage *)image {
 
    NSData *data = UIImagePNGRepresentation(image);
    [BmobProFile uploadFileWithFilename:@"用户图标" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        
        if (isSuccessful == YES) {
            NSLog(@"url = %@", url);
            NSLog(@"file = %@", file);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
            //将上传的图片链接和用户联系起来
            BmobUser *bUser = [BmobUser getCurrentUser];
            [bUser setObject:file.url forKey:@"userIconUrl"];
            //参数名重复。。。手动修改
            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuc, NSError *err) {
               
                if (isSuc == YES) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"关联成功"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:file.url]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:User_Refresh_Notice object:nil userInfo:nil];
                    });

                } else {
                    
                    [SVProgressHUD showErrorWithStatus: err.localizedDescription];
                }
            }];
            
          
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:^(CGFloat progress) {
        //显示上传进度
        [SVProgressHUD showProgress:progress];
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
