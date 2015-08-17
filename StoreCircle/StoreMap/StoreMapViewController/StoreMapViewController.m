//
//  StoreMapViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/6/4.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreMapViewController.h"
#import "GlobalMacro.h"
#import "SJAvatarBrowser.h"



@interface StoreMapViewController ()<BMKMapViewDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, assign) CLLocationCoordinate2D location;

@end

@implementation StoreMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton=YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"商铺地址";
    
    _searcher =[[BMKGeoCodeSearch alloc]init];
//    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    //河南省洛阳市洛龙区王城大道90号  北京经济技术开发区荣昌东街甲5号a座101单元
    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = @"经济技术开发区荣昌东街甲5号a座101单元";
   // BOOL flag = [_searcher geoCode:geoCodeSearchOption];
//    [geoCodeSearchOption release];
//    if(flag)
//    {
//        NSLog(@"geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"geo检索发送失败");
//    }
    
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _mapView.delegate=self;
    self.mapView.mapType=BMKMapTypeStandard;
    self.mapView.zoomLevel=14;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.latitude floatValue];
    coor.longitude = [self.longitude floatValue];
    annotation.coordinate = coor;
    annotation.title = @"商铺地址";
    [_mapView addAnnotation:annotation];
    //将标注移到视图中心
    [_mapView showAnnotations:[NSArray arrayWithObject:annotation] animated:YES];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 获取坐标的代理
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"result....%@",result);
        self.location=result.location;
        NSLog(@"%f location",self.location.latitude);
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = result.location.latitude;
        coor.longitude = result.location.longitude;
        annotation.coordinate = coor;
        annotation.title = @"商铺地址";
        [_mapView addAnnotation:annotation];
        //将标注移到视图中心
        [_mapView showAnnotations:[NSArray arrayWithObject:annotation] animated:YES];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
    
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


- (void)viewWillDisappear:(BOOL)animated{
    
    self.mapView.delegate=nil;
    self.mapView=nil;
    
    
}
@end
