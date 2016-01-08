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
#import "VerifyPhoneViewController.h"

typedef NS_ENUM(NSInteger, ChosePhotoType) {

    ChosePhotoTypeAlbum,
    ChosePhotoTypeCamera
};

@interface UserInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    BOOL _isVerified;
}
@property (weak, nonatomic) IBOutlet MyImageView *userIcon;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self userRefresh:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)userRefresh:(NSNotification *)notice {
    
    //获取到用户的用户名(从沙盒中取 bmob会自动将用户信息存入沙盒)
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    BOOL isPhoneVerified = [bUser objectForKey:@"mobilePhoneNumberVerified"];
    if (isPhoneVerified) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        cell.textLabel.text = @"手机号已验证";
        _isVerified = YES;
    } else {
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
        cell.textLabel.text = @"验证手机号";
        _isVerified = NO;
    }
    
    
    if (bUser) {
        
        NSString *urlString = [bUser objectForKey:@"userIconUrl"];
        if (urlString == nil) {
            return;
        }
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlString]];
    } else {
        
        self.userIcon.image = [UIImage imageNamed:@"avatar_default_big"];
    }
}

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
    picker.allowsEditing = YES; //可编辑
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
    picker.editing = YES;
    //原始图片
//    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    //编辑之后的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    NSData *imageData = nil;
    
//    //图片存到本地 -- 拼接一个沙盒路径 创建文件夹和文件
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
////    NSLog(@"%@", documentPath);
//    NSString *imageDirPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    //如果文件夹已经存在 就不需要创建
//    if ([fileManager fileExistsAtPath:imageDirPath]) {
//        
//    } else {
//        
//        //创建文件夹
//        [fileManager createDirectoryAtPath:imageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSData *saveImageData = UIImagePNGRepresentation(image);
//    NSString *imagePath = [imageDirPath stringByAppendingPathComponent:@"userIcon"];
//    BOOL isSuccess = [saveImageData writeToFile:imagePath atomically:YES];
//    
//    if (isSuccess) {
//        
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//    } else {
//    
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
//    }
////    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) 存到相册
    
    
    if (UIImagePNGRepresentation(image)) {
        
        imageData = UIImagePNGRepresentation(image);
    } else if (UIImageJPEGRepresentation(image, 0.5)) {
        
        imageData = UIImageJPEGRepresentation(image, 0.5);
    }
//
//    //压缩处理
//    imageData = UIImageJPEGRepresentation(image, 0.5);
    
    //将图片尺寸变小
    UIImage *compressedImage = [self compressImageWithData:imageData limitedWidth:200];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self uploadImageWithImage:compressedImage];
    }];
}

- (UIImage *)compressImageWithData:(NSData *)imageData limitedWidth:(CGFloat)width{
   
    //获取图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    //创建新的图片大小  限制宽度 等比缩放之后显示部分高度
    CGSize oldImageSize = image.size;
    
    //判断传入值是否是在压缩 若超过原来 则不变
    if (width > oldImageSize.width) {
        width = oldImageSize.width;
    }
    
    CGFloat newHeight = oldImageSize.height * (CGFloat)width / oldImageSize.width;
    CGSize newSize = CGSizeMake(width, newHeight);
    
    //开启一个图片句柄
    UIGraphicsBeginImageContext(newSize);
    
    //将图片画入新的size里面
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //从图片句柄中获取一张新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭文件句柄
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**上传文件到Bmob服务器*/
- (void)uploadImageWithImage:(UIImage *)image {
 
    NSData *data = UIImagePNGRepresentation(image);
    [BmobProFile uploadFileWithFilename:@"用户图标" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        
        if (isSuccessful == YES) {
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
            //获取服务器处理之后图片的地址 传入服务器上图片的地址 在Block中返回对象
            [BmobImage cutImageBySpecifiesTheWidth:100 height:100 quality:50 sourceImageUrl:file.url outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
                
                //object里面 处理之后图片的url group filename
                BmobFile *resFile = object;
                NSString *resUrl = resFile.url;
                
                [self.userIcon sd_setImageWithURL:[NSURL URLWithString:resUrl]];
                NSLog(@"%@", resUrl);
                [[NSNotificationCenter defaultCenter] postNotificationName:User_Refresh_Notice object:nil userInfo:nil];
            }];
            
            //将上传的图片链接和用户联系起来
            BmobUser *bUser = [BmobUser getCurrentUser];
            [bUser setObject:file.url forKey:@"userIconUrl"];
            //参数名重复。。。手动修改
            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuc, NSError *err) {
               
                if (isSuc == YES) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"关联成功"];
                   
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

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_isVerified) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    switch (indexPath.row) {
        case 0:
        {    //
            VerifyPhoneViewController *verifyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneViewController"];
            verifyVC.phonebindBlock = ^{
                
                _isVerified = YES;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
                cell.textLabel.text = @"手机号已验证";
            };
            
            [self.navigationController pushViewController:verifyVC animated:YES];
        }   break;
            
        default:
            break;
    }
}

@end
