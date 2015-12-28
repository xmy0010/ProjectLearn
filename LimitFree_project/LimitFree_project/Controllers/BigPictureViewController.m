//
//  BigPictureViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/18.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "BigPictureViewController.h"
#import "AppdetailModel.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"

@interface BigPictureViewController ()<UIScrollViewDelegate> {
    
    UIImageView *_topImageView;//顶部的图片
    UIScrollView *_bigPictureScrollView; //中间部分的滚动视图
    UIImageView *_bottomImageView;//底部的图片
    
    UILabel *_titleLable;
    UIButton *_doneButton;
    UIButton *_saveButton;
    
}

@end

@implementation BigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createUI];
    
    [self fillUI];
    
    //通过KVO方式监听selectedIndex值变化
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    //1.修改状态栏的样式 黑和白俩种defaul为黑
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //2.在plist文件中添加使视图控制器能够修改状态栏 这个是app对象单例修改 会对全局进行修改
    //View controller-based status bar appearance 设置为NO
    
    //整个程序的状态栏可以在general - deployment info中设置
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//创建视图
- (void)createUI {

    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kScreenSize.width, 44)];
    [self.view addSubview:_topImageView];
    _topImageView.image = [UIImage imageNamed:@"tabbar_bg"];

    
    _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 44, kScreenSize.width, 44)];
    [self.view addSubview:_bottomImageView];
    _bottomImageView.image = [UIImage imageNamed:@"tabbar_bg"];

    
    _bigPictureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImageView.frame), kScreenSize.width, kScreenSize.height - CGRectGetMaxY(_topImageView.frame) - CGRectGetHeight(_bottomImageView.frame))];
    [self.view addSubview:_bigPictureScrollView];
    _bigPictureScrollView.backgroundColor = [UIColor blackColor];
    _bigPictureScrollView.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBigPictureTap:)];
    [_bigPictureScrollView addGestureRecognizer:tapGesture];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_topImageView.frame) / 2 - 100, 0, 200, CGRectGetHeight(_topImageView.frame))];
    [_topImageView addSubview:_titleLable];
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont systemFontOfSize:20];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_topImageView addSubview:_doneButton];
    _doneButton.frame = CGRectMake(CGRectGetWidth(_topImageView.frame) - 60, 7, 50, 30);
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_bottomImageView addSubview:_saveButton];
    _saveButton.frame = _doneButton.frame;
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _topImageView.userInteractionEnabled = YES;
    _bottomImageView.userInteractionEnabled = YES;
}

- (void)fillUI {

    _titleLable.text = [NSString stringWithFormat:@"%ld of %ld", self.selectedIndex + 1, self.photos.count];
    
    
    CGSize scrollViewSize = _bigPictureScrollView.frame.size;
    CGFloat imageViewHeight = scrollViewSize.width / 1.8;
    for (int index = 0; index < self.photos.count; index++) {
        //获取对应的模型数据
        Photos *photo = self.photos[index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( index * scrollViewSize.width, scrollViewSize.height / 2 - imageViewHeight / 2, scrollViewSize.width, imageViewHeight)];
        [_bigPictureScrollView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:photo.originalUrl] placeholderImage:[UIImage imageNamed:@"user_background"]];
    }
    //设置内容尺寸
    _bigPictureScrollView.contentSize = CGSizeMake(self.photos.count * scrollViewSize.width, scrollViewSize.height);
    _bigPictureScrollView.pagingEnabled = YES;
    _bigPictureScrollView.bounces = NO;
    
    //让滚动视图跳转到相对应的位置
    _bigPictureScrollView.contentOffset = CGPointMake(self.selectedIndex * scrollViewSize.width, 0);
}

#pragma mark - Actions

- (void)onBigPictureTap:(UITapGestureRecognizer *)sender {
   
    if ([_topImageView isHidden]) {
        _topImageView.hidden = NO;
        _bottomImageView.hidden = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
    } else {
        _topImageView.hidden = YES;
        _bottomImageView.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
    }

}

- (void)doneButtonClicked:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonClicked:(UIButton *)sender {

    //获取当前scrollview里面显示的imageView
    UIImageView *imageView = _bigPictureScrollView.subviews[self.selectedIndex];
    //保存UIImageView上的图片 到相册中
    //参数一是imageView的image
    //参数二三 target-action  action有固定样式
    //参数四：上下文
    UIImageWriteToSavedPhotosAlbum(imageView.image, self,@selector(image: didFinishSavingWithError: contextInfo:), nil);
    
}

//对应这个样式的方法保存图片
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

    [KVNProgress showWithStatus:@"保存中..."];
    
    if (error) {
        NSLog(@"保存失败");
        [KVNProgress showErrorWithStatus:@"保存失败,请再次尝试"];
    } else {
        NSLog(@"保存成功");
        [KVNProgress showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark - <UIScrollViewDelegate>
//减速结束回调方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    self.selectedIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    _titleLable.text = [NSString stringWithFormat:@"%ld of %ld", self.selectedIndex + 1, self.photos.count];
}


#pragma mark - touch事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//     //判断视图是否被隐藏
//    if ([_topImageView isHidden]) {
//        _topImageView.hidden = NO;
//        _bottomImageView.hidden = NO;
//    } else {
//        _topImageView.hidden = YES;
//        _bottomImageView.hidden = YES;
//    }
//}

//移除观察者
- (void)dealloc {

    [self removeObserver:self forKeyPath:@"selectedIndex"];
}

@end
