//
//  WaitView1ViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/5/27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "WaitView1ViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "GlobalMacro.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKAnnotation.h>
#import <MapKit/MapKit.h>


@interface WaitView1ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManger;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic)CGFloat latitudes;

@property (nonatomic)CGFloat longitudes;


@end

@implementation WaitView1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView.mapType=BMKMapTypeStandard;
    self.mapView.zoomLevel=14;
    self.mapView.showsUserLocation=YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    
    
    _locationManger=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            
            [_locationManger requestWhenInUseAuthorization];

        }
        
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];

        //启动LocationService
        [_locService startUserLocationService];
        
    }else{
        NSLog(@"yidakai");
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
        
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
        
    }


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
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _locService.delegate=self;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _locService.delegate=nil;
    
}

#pragma mark - 定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitudes=userLocation.location.coordinate.latitude;
    self.longitudes=userLocation.location.coordinate.longitude;
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.latitudes;
    coor.longitude = self.longitudes;
    annotation.coordinate = coor;
    annotation.title = @"您的位置";
    [_mapView addAnnotation:annotation];
    
}



#pragma mark -地图代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
