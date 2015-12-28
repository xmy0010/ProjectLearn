//
//  AppDetailViewController.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/17.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "AppDetailViewController.h"
#import "AppdetailModel.h"
#import "LimitFressNetworkingManager.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "AppModel.h"
#import "BigPictureViewController.h"
#import "DatabaseManager.h" // 数据库管理头文件
#import "CollectionTableModel.h"

#import "UMSocial.h"

//app图片展示第一张的tag
#define APP_PICTURE_BEGIN_TAG 10
//附近的人使用的app的tag值
#define NEAR_APP_BEGIN_TAG 100

@interface AppDetailViewController () < CLLocationManagerDelegate>{

    
}

@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *appPictureScrollView;
@property (weak, nonatomic) IBOutlet UITextView *appDescTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *recommendAppScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageVIew;

@property (nonatomic, strong) LimitFressNetworkingManager *manager;
@property (nonatomic, strong) AppdetailModel *detailModel;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSArray *nearAppArray;

- (IBAction)shareClicked:(UIButton *)sender;
- (IBAction)favoriteClicked:(UIButton *)sender;
- (IBAction)downloadClicked:(UIButton *)sender;


@end

@implementation AppDetailViewController

- (AppdetailModel *)detailModel {

    if (_detailModel == nil) {
        _detailModel = [[AppdetailModel alloc] init];
    }
    return _detailModel;
}

- (LimitFressNetworkingManager *)manager {
 
    if (_manager == nil) {
        _manager = [LimitFressNetworkingManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationItem];
    
    [self requestDetailModel];
    
    [self createLocationManager];
    
    //判断当前应用是否已收藏
    BOOL isCollection  = [[DatabaseManager sharedManager] isExistsWithAppId:self.applicationID];
    //修改收藏按钮的状态
    self.favoriteButton.enabled = !isCollection;
}

//定制导航项
- (void)customNavigationItem {

    [self addNavigationItemTilte:@"应用详情"];
    [self addBarButtonItemWithTarget:self action:@selector(back:) name:@"返回" isLeft:YES];
    UIButton *leftButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"buttonbar_back"] forState:UIControlStateNormal];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)onNearAppTap:(UITapGestureRecognizer *)sender {
 
    NSInteger selectedTag = sender.view.tag - NEAR_APP_BEGIN_TAG;
    
    //取出对应的模型数据
    AppModel *model = self.nearAppArray[selectedTag];
    AppDetailViewController *detailVC = [[AppDetailViewController alloc] init];
    detailVC.applicationID = model.applicationId;
    //push出来
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

//app图片点击
- (void)onAppPictureTap:(UITapGestureRecognizer *)sender {

    //获取点击的图片
    UIView *tapView = sender.view;
    //获取对应的index值
    NSInteger selectedIndex = tapView.tag - APP_PICTURE_BEGIN_TAG;
    
    BigPictureViewController *bigPicVC = [[BigPictureViewController alloc] init];
    bigPicVC.photos = self.detailModel.photos;
    bigPicVC.selectedIndex = selectedIndex;
    bigPicVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:bigPicVC animated:YES completion:nil];
    
}

- (void)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareClicked:(UIButton *)sender {
    
    //分享的文字
    NSString *shareText = [NSString stringWithFormat:@"%@ %@ %@", self.detailModel.name, self.detailModel.desc, self.detailModel.itunesUrl];
    
    UIImage *shareImage = [self.appImageView.image copy];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:nil
                                       delegate:nil];
}

- (IBAction)favoriteClicked:(UIButton *)sender {
    //判断是否已在家
    if (!self.detailModel) {
        [KVNProgress showErrorWithStatus:@"应用详情暂未加载"];
        return;
    }
    
    
    //创建模型
    CollectionTableModel *model = [[CollectionTableModel alloc] init];
    model.appId = self.detailModel.applicationId;
    model.appName = self.detailModel.name;
    model.appImage = self.detailModel.iconUrl;
    
    BOOL isSuccess = [[DatabaseManager sharedManager] insertCollectionTableModel:model];
    if (isSuccess) {
        self.favoriteButton.enabled = NO;
        [KVNProgress showSuccessWithStatus:@"收藏成功"];
    } else {
        [KVNProgress showErrorWithStatus:@"收藏失败"];
        
    }

}

- (IBAction)downloadClicked:(UIButton *)sender {
    // 打开URL地址
    
//    //打开网址
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://baidu.com"]];
//    //拨打电话
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://180XXXX9999"]];//真机可拨打
    //发邮件
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://972321991@qq.com"]];
    
    //下载应用需要跳转到App Store中
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detailModel.itunesUrl]];
}


#pragma mark - About Data 
- (void)requestDetailModel {
    self.manager = [LimitFressNetworkingManager manager];
    
    NSString *detailURL = [NSString stringWithFormat:kDetailUrl, self.applicationID];
    
    //将self变成weak指针
    __weak typeof (self) weakSelf = self;
    [self.manager GET:detailURL parameters:nil success:^(NSData *data, NSURLResponse *response) {
      
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [weakSelf.detailModel setValuesForKeysWithDictionary:responseDict];
        //回到主队列中更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSelf updateUI];
        });
        
        
    } failure:^(NSURLResponse *response, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

//请求附近在使用的App信息
- (void)requestNearAppData {

    //拼接请求地址
    NSString *nearAppURL = [NSString stringWithFormat:kNearAppUrl, self.location.coordinate.longitude, self.location.coordinate.latitude];
    
    //请求数据
    [self.manager GET:nearAppURL parameters:nil success:^(NSData *data, NSURLResponse *response) {
       
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *applications = responseDict[@"applications"];
        NSMutableArray *tempApps = [NSMutableArray array];
        for (NSDictionary *dict in applications) {
            AppModel *model = [[AppModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            [tempApps addObject:model];
        }
        self.nearAppArray = [tempApps copy];
        
        //回到主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateNearApp];
        });
        
    } failure:^(NSURLResponse *response, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - UI

//更新UI
- (void)updateUI {

    NSLog(@"%@, %@", NSStringFromCGRect(self.contentView.frame), NSStringFromCGRect(self.backgroudImageVIew.frame));
    [self.appImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    self.appName.text = self.detailModel.name;
    
    self.price.text = [NSString stringWithFormat:@"原价:￥%@ 限免中 文件大小:%@MB", _detailModel.lastPrice, _detailModel.fileSize];
    
    self.category.text = [NSString stringWithFormat:@"类型:%@ 评分:%@", _detailModel.categoryName, _detailModel.starOverall];
    
    self.appDescTextView.text = self.detailModel.desc;
    self.appDescTextView.userInteractionEnabled = NO;
    
    
    //显示滚动图片 在AutoLayout中 如果界面还没有显示出来 获取的frame只是在xib或者storyboard中对应的尺寸 不是在约束对应设备的尺寸 要在一个AutoLayout布局的视图中添加子视图时  一是添加后建立约束 另一种是等到UI加载完成时才使用
    
    //遍历图片数组
    CGFloat imageHeight = CGRectGetHeight(self.appPictureScrollView.frame);
    for (int index = 0; index < self.detailModel.photos.count; index++) {
        //取出对应的模型
        Photos *photo = self.detailModel.photos[index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * imageHeight, 0, imageHeight, imageHeight)];
        
        //将图片视图添加到滚动视图中
        [self.appPictureScrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photo.smallUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
        
        //开启用户交互
        imageView.userInteractionEnabled = YES;
        //添加tap手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAppPictureTap:)];
        [imageView addGestureRecognizer:tapGesture];
        //设置标记值
        imageView.tag = APP_PICTURE_BEGIN_TAG + index;

    }
    //设置内容的尺寸
    self.appPictureScrollView.contentSize = CGSizeMake(imageHeight * self.detailModel.photos.count, imageHeight);
    
}

//更新附近的app数据
- (void)updateNearApp {
    
    //获取图片的尺寸
    CGFloat imageHeight = CGRectGetHeight(self.recommendAppScrollView.frame);
    for (int index = 0; index < self.nearAppArray.count; index++) {
        AppModel *model = self.nearAppArray[index];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * imageHeight, 25, imageHeight, imageHeight - 25)];
        [self.recommendAppScrollView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    
        
        //添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNearAppTap:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.tag = NEAR_APP_BEGIN_TAG + index;
        imageView.userInteractionEnabled =  YES;

    }
    //设置contentSize
    self.recommendAppScrollView.contentSize = CGSizeMake(imageHeight * self.nearAppArray.count, imageHeight);
    
    
  }

#pragma mark - AboutLocation
- (void)createLocationManager {
    
    self.locationManager =  [[CLLocationManager alloc] init];
    //设置代理
    self.locationManager.delegate = self;
    //定位的更新频率
    self.locationManager.distanceFilter = 100.;
    //定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //请求用户权限
    //判断当前应用是否已授权
    CLAuthorizationStatus statu = [CLLocationManager authorizationStatus];
    if (statu == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
    //pilst文件中添加描述信息 NSLocationAlwaysUsageDesciption
    //开始定位
    [self.locationManager startUpdatingLocation];
    //下方实现代理
}

#pragma mark - CLLocationManagerDelegate 
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count != 0) {
        //任意取一个定位信息
        self.location = [locations firstObject];
        //根据经纬度请求数据
        [self requestNearAppData];
        
        //停止定位服务
        [self.locationManager stopUpdatingLocation];
    }
    
}



@end
