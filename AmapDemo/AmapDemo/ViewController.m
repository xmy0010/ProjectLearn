//
//  ViewController.m
//  AmapDemo
//
//  Created by 千锋 on 15/12/4.
//  Copyright (c) 2015年 千锋. All rights reserved.

//http://lbs.amap.com
//com.1000phone.3G.AMapDemo (info.plist里面的bundle identifier 的value)
//other linker flag -ObjC

//依赖库：1.CoreLocation 2.libz  3.libstdc++.6.0.9.dylib  4.CoreTelephony  5.systemConfiguration

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h> // 高德地图头文件
#import <AMapSearchKit/AMapSearchKit.h>




@interface ViewController () <MAMapViewDelegate, AMapSearchDelegate, CLLocationManagerDelegate> {
    MAMapView *_mapView; //地图视图
    MAUserLocation *_location; //位置
    AMapSearchAPI *_search;
    CLLocationCoordinate2D _coordinate2D;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self createMapView];
    [self customNavigationBar];
}

//创建地图
- (void)createMapView {

    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    
    _mapView.showTraffic = YES;//显示交通
    
    //需要在plist中加NSLocationAlwaysUsageDescription
    _mapView.showsUserLocation = YES; //打开定位
    
    [_mapView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addSelfAnnotation:)]];
    _mapView.delegate = self;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}



//
- (void)customNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonItemClicked:)];
}



- (void)createMapSearch {
    _search = [AMapSearchAPI new];
    _search.delegate = self;
    
    
    //g构造Request
    AMapPOIAroundSearchRequest *request = [AMapPOIAroundSearchRequest new];
    
    _location = [MAUserLocation new];
    request.location = [AMapGeoPoint locationWithLatitude:_coordinate2D.latitude longitude:_coordinate2D.longitude];
    request.keywords = @"省医院";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"公共设施 | 公司企业";
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];
    
}

- (void)addSelfAnnotation:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint gesturePoint = [sender locationInView:_mapView];
    _coordinate2D = [_mapView convertPoint:gesturePoint toCoordinateFromView:_mapView];
    
    MAPointAnnotation *annotation = [MAPointAnnotation new];
    annotation.coordinate = _coordinate2D;
    annotation.title = @"大头针";
    annotation.subtitle = @"您添加在地图上的大头针";
    

    
    [_mapView addAnnotation:annotation];
}

- (void)searchBarButtonItemClicked:(UIBarButtonItem *)sender {
    [self createMapSearch];
}




#pragma mark - <MAMapViewDelegate>

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *annotationIdentifier = @"Annotation";
        
        MAPinAnnotationView *annotationView =  (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        annotationView.canShowCallout = YES; //气泡弹出 默认NO
        annotationView.animatesDrop = YES; //标注动画显示 默认NO
        annotationView.pinColor = MAPinAnnotationColorGreen;
        
        return annotationView;

    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        if (_location == nil) {
            _location = [MAUserLocation new];
        }
        _location = userLocation;
    }
}

#pragma mark - <AMapSearchDelegate>
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {

}

@end
