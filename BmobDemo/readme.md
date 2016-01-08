##BmobDemo
this demo is a project with register and longin to learn Bmob.

### `UITextField`可添加事件Editing changed。区分vanlue changed
### md5加密
### Xcode 代码自动对齐 选中代码段 ctrl+i


###1.按一定尺寸裁剪图片
```Obj-c
- (UIImage *)compressImageWithData:(NSData *)imageData {
   
    //获取图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    //创建新的图片大小
    CGSize size = CGSizeMake(100, 100);
    
    //开启一个图片句柄
    UIGraphicsBeginImageContext(size);
    
    //将图片画入新的size里面
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //从图片句柄中获取一张新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭文件句柄
    UIGraphicsEndImageContext();
    
    return newImage;
}
