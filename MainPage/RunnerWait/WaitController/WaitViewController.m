 //
//  WaitViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "WaitViewController.h"
#import "WaitView.h"
#import <BaiduMapAPI/BMapKit.h>
#import "PayView.h"
#import "PayOrder.h"
#import "NetworkRequest.h"
#import "PayViewController.h"
#import "PayFinish.h"
#import "URLMacro.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "GlobalMacro.h"
#import "AnswerViewController.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import "Singleton.h"
#import "CustomAlertView.h"
#import "RunnerStoreViewController.h"


@interface WaitViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UIAlertViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) WaitView *waitView;

@property (nonatomic, strong) CLLocationManager *locationManger;

@property (nonatomic)CGFloat latitudes;

@property (nonatomic)CGFloat longitudes;

@property (nonatomic, strong)BMKLocationService *locService;

@property (nonatomic, assign) int timeCount;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PayView *payView;

@property (nonatomic, strong) PayOrder *payOrder;

@property (nonatomic, strong) PayFinish *payFinish;

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *phoneNum;


//客服电话
@property (nonatomic, strong) NSString *telephone;

@end

@implementation WaitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)loadView{
    [super loadView];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(isLogin1)];
    right.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=right;
    
    self.mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView.mapType=BMKMapTypeStandard;
    self.mapView.zoomLevel=14;
    self.mapView.showsUserLocation=YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    [self waitOrderView];
    
    
    //创建倒计时90 后展示的视图
    
    self.myAlert = [[CustomAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.myAlert CreateMyCustomAlert];
    
    self.myAlert.backgroundColor = [UIColor clearColor];
    
//    self.myAlert.center = self.view.center;
    
    [self.view addSubview:self.myAlert];
    
    self.myAlert.hidden = YES;
    
    [self.myAlert.continueRush addTarget:self action:@selector(continueRushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.myAlert.contactServer addTarget:self action:@selector(contactServerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.myAlert.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self getContactPhoneNumber];

    self.navigationItem.title=@"快跑兄弟";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    _locationManger=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    Singleton *share = [Singleton shareInstance];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        //  [_locationManger requestWhenInUseAuthorization];
        NSLog(@"requestwhen");
        
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        
        //初始化BMKLocationService
        
//        shrelocService = [[BMKLocationService alloc]init];
        share.locService.delegate = self;
        //启动LocationService
        [share.locService startUserLocationService];
        
    }else{
        NSLog(@"yidakai");
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        
        //初始化BMKLocationService
//        _locService = [[BMKLocationService alloc]init];
        share.locService.delegate = self;
        //启动LocationService
        [share.locService startUserLocationService];
        
    }
    
    
    self.timeCount = 90;
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderNotification:) name:@"ORDER_LIST" object:nil];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.latitudes;
    coor.longitude = self.longitudes;
    annotation.coordinate = coor;
    annotation.title = @"您的位置";
    [_mapView addAnnotation:annotation];

   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    Singleton *share = [Singleton shareInstance];
    share.locService.delegate=nil;
    
    [share.locService stopUserLocationService];
    
    
}

#pragma mark - 将要启动
- (void)willStartLocatingUser
{
    NSLog(@"start = = = ");
}

#pragma mark - 定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitudes=userLocation.location.coordinate.latitude;
    self.longitudes=userLocation.location.coordinate.longitude;
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    
   
    
}

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

//倒计时
- (void)timeAction:(id)sender{
    
    if (self.timeCount>0) {
        self.timeCount--;
        self.waitView.label2.text=[NSString stringWithFormat:@"%d秒",self.timeCount];
    }
    else{
        [self.timer invalidate];

        //倒计时120秒 后要执行的操作
        
        self.myAlert.hidden = NO;
        
        
        self.waitView.hidden = YES;
        
    }
        

}

#pragma mark - 创建收到消息后的隐藏界面
- (void)createAnswerView{
    
    
    //个人信息
    
    self.payView=[[PayView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    [self.payView.headImg setImage:[UIImage imageNamed:@"dachea"]];
    [self.payView.phone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payView];
    [self.payView.backPhone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressTap:)];
    tap.numberOfTapsRequired=1;
    [self.payView addGestureRecognizer:tap];
    
    
    
    
    //订单信息
    self.payOrder=[[PayOrder alloc] initWithFrame:CGRectMake(10, self.payView.frame.origin.y + self.payView.frame.size.height + 10, SCREEN_WIDTH - 20, 85) cost:nil award:nil];
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"此单将花费 5元"];
    self.payOrder.cost.attributedText = [GlobalMethod fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(6, 2) AndColor:[UIColor redColor]];
    self.payOrder.layer.borderColor = [[UIColor grayColor] CGColor];
    self.payOrder.layer.borderWidth = 0.5;
    [self.payOrder addTarget:self action:@selector(toStoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payOrder];
    
    
    
    //底部 支付
    self.payFinish=[[PayFinish alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-55, SCREEN_WIDTH, 55)];
    [self.view addSubview:self.payFinish];
    [self.payFinish.pay addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.payFinish.finish addTarget:self action:@selector(finishPay) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 前往快跑商城
- (void)toStoreAction:(id)sender
{
    RunnerStoreViewController *store = [[RunnerStoreViewController alloc] init];
    
    
    [self.navigationController pushViewController:store animated:YES];
    
//    [self.navigationController pushViewController:store animated:YES];
    
}


- (void)waitOrderView{
    
    self.waitView=[[WaitView alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, SCREEN_HEIGHT/6)];
    self.waitView.label1.text=@"正在呼叫，请耐心等待";
    self.waitView.label3.text=@"后取消呼叫";
    
    
    [self.view addSubview:self.waitView];

}

//刷新坐标
- (void)refreshLocation:(id)orderId{
    NSString *url=GET_LOCATION;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=self.orderId;
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *longtitude=[dic objectForKey:@"longitude"];
        NSString *latitude=[dic objectForKey:@"latitude"];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [latitude floatValue];;
        coor.longitude =[longtitude floatValue];
        annotation.coordinate = coor;
        annotation.title = @"快跑者的位置";
        [_mapView addAnnotation:annotation];
        
        
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([latitude floatValue],[longtitude floatValue]));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.latitudes,self.longitudes));
        [self changeMap:point1 and:point2];

    } ErrorBlock:^(id error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络不好" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
    
    
}


/**
 *  跳转到支付页面
 */
- (void)payAction:(id)sender{
    PayViewController *pay=[[PayViewController alloc]init];
    pay.orderId=self.ordersId;
    [self.navigationController pushViewController:pay animated:YES];
    
}

/**
 *  取消订单
 */
- (void)cancleAction:(id)sender{
    [self.timer invalidate];
    NSString *url=POST_CANCELORDER;
    NSString *orderId=self.ordersId;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=orderId;
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result %@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *flag=[dic objectForKey:@"flag"];
        if ([flag isEqualToString:@"1"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"取消成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@ error",error);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接异常,请重试" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
 
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

    }];
    
    
}




//获取推送订单字典
- (NSDictionary *)pushNotificationOrderList
{
    Singleton *share = [Singleton shareInstance];
    NSLog(@"order_list = %@", share.orderList);
    return share.orderList;
}

#pragma mark - 获取客服联系电话
- (void)getContactPhoneNumber
{
    
    [NetworkRequest netWorkRequestPOSTWithString:@"http://123.57.222.175:8080/runfast/UsersAction!appVersion.action" Parameters:nil ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSDictionary *mydic = [GlobalMethod dictionaryResults:result];
        self.telephone = [mydic objectForKey:@"phone"];
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

        
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    [_mapView viewWillAppear];
    Singleton *share =[Singleton shareInstance];
    _mapView.delegate=self;
    share.locService.delegate=self;

    
    NSDictionary *dic = [self pushNotificationOrderList];
    
    NSLog(@"%@", dic);
    self.orderDic = nil;
    NSDictionary *order = [dic objectForKey:@"msg"];
    self.orderDic = [NSDictionary dictionaryWithDictionary:order];
    if ([self.orderDic objectForKey:@"id"]!=nil) {
        //显示界面
        NSLog(@"dicorder%@",self.orderDic);
        self.orderId=[self.orderDic objectForKey:@"id"];
        NSString *longitude=[self.orderDic objectForKey:@"longitude"];
        NSString *latitude=[self.orderDic objectForKey:@"latitude"];
        [self locationNow:longitude and:latitude];
        NSLog(@"在这里显示隐藏界面!!!!");
        [self.waitView removeFromSuperview];
        
        UIImage *image = [UIImage imageNamed:@"run"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(refreshLocation:)];
        self.navigationItem.rightBarButtonItem=right;
        [self.timer invalidate];
        [self createAnswerView];

    }
    
}

//销毁通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ORDER_LIST" object:nil];
}

//通知调用方法, 一直在这个页面的时候 会调用
- (void)orderNotification:(NSNotification *)notification
{
    NSLog(@"noti = %@", notification.userInfo);
    self.orderDic = nil;
    NSDictionary *order = [notification.userInfo objectForKey:@"msg"];
    self.orderDic = [NSDictionary dictionaryWithDictionary:order];
    if ([self.orderDic objectForKey:@"id"]!=nil) {
        NSLog(@"dicorder %@",self.orderDic);
        self.orderId=[self.orderDic objectForKey:@"id"];
        NSLog(@"在这里显示隐藏界面!!!!");
        NSString *longitude=[self.orderDic objectForKey:@"longitude"];
        NSString *latitude=[self.orderDic objectForKey:@"latitude"];
        [self locationNow:longitude and:latitude];
        [self.waitView removeFromSuperview];
        
        UIImage *image = [UIImage imageNamed:@"run"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(refreshLocation:)];
        self.navigationItem.rightBarButtonItem=right;
        [self getOrderPeople:nil];
        [self.timer invalidate];
       // [self createAnswerView];

        
    }
    
    
}
//立刻定位
- (void)locationNow :(NSString *)longtitude and:(NSString *)latitude {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [latitude floatValue];;
    coor.longitude =[longtitude floatValue];
    annotation.coordinate = coor;
    annotation.title = @"快跑者的位置";
    [_mapView addAnnotation:annotation];
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([latitude floatValue],[longtitude floatValue]));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.latitudes,self.longitudes));
    [self changeMap:point1 and:point2];
    
    

}
//得到订单人信息
- (void)getOrderPeople:(id)sender{
    NSString *url=POST_SALESINFORMATION;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[self.orderDic objectForKey:@"id"];
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result====%@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
               self.phoneNum=[dic objectForKey:@"mobileNo"];
        if ([self.payView.name.text isEqualToString:@""]||self.payView.name.text==nil) {
            [self createAnswerView];
            self.payView.name.text=[dic objectForKey:@"nickName"];
            self.payView.carId.text=[dic objectForKey:@"carNo"];
            
            NSMutableString *string = [NSMutableString stringWithFormat:@"完成订单  奖励%@银币",[dic objectForKey:@"gold"]];
            
            self.payOrder.award.attributedText=[GlobalMethod fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(8, 3) AndColor:[UIColor orangeColor]];
            
            [self.payView.headImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headImg"]] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];

        }
       
    } ErrorBlock:^(id error) {
        NSLog(@"%@ error",error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }];
    
    
}
//打电话
- (void)phoneAction:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneNum];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}



- (void)isLogin1{
    
    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self cancleAction:nil];
        
    } ErrorBlock:^(id error) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

        
    }];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==111) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user setObject:@"logout" forKey:@"logout"];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }
    
    


    
   
}

//90s后页面
#pragma mark - 继续抢
- (void)continueRushAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:[UIColor lightGrayColor]];
    
    [NetworkRequest netWorkRequestPOSTWithString:@"http://123.57.222.175:8080/runfast/OrderAction!orderAddAgain.action?" Parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.ordersId, @"ordeId",nil] ResponseBlock:^(id result) {
        
        NSLog(@"%@", result);
        
        
        self.timeCount = 90;
        self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        [self.myAlert setHidden:YES];
        self.waitView.hidden = NO;
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        [self.myAlert setHidden:YES];
        self.waitView.hidden = NO;

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
    }];

}

#pragma mark - 打电话给客服

- (void)contactServerAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:[UIColor lightGrayColor]];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.telephone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
    
    //记录拨打电话次数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [NetworkRequest netWorkRequestPOSTWithString:@"http://123.57.222.175:8080/runfast/OrderAction!phoneRecord.action?" Parameters:[GlobalMethod paramatersForValues:@[[user objectForKey:@"userId"], @"1", self.telephone] keys:@"id,type,phone"] ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        
        if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
            self.myAlert.hidden = YES;
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@ error", error);
        
        self.myAlert.hidden = YES;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        

    }];

}

#pragma mark - 取消订单

- (void)cancelButtonAction:(id)sender
{
    self.myAlert.hidden = YES;
    
    [self cancleAction:nil];
    
    
}



- (void)finishPay{
    
    [self payCashAction:nil];
    
}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        
        if ([alert.title isEqualToString:@"订单已完成"]) {
            
            NSLog(@"%@", self.navigationController.viewControllers);
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        }
        
        if ([alert.title isEqualToString:@"取消成功"]) {
            
            [self.navigationController popViewControllerAnimated:YES];

        }
        
        if ([alert.title isEqualToString:@"网络连接出现错误"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        if ([alert.title isEqualToString:@"支付完成"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }
}


//手势单击取消订单视图
- (void)pressTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self.payOrder removeFromSuperview];
    
}

//改变地图的比例尺
- (void)changeMap:(BMKMapPoint)point1 and:(BMKMapPoint)point2{
    
//    BMKMapPoint point11 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
//    BMKMapPoint point21 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    if (distance<=50) {
        self.mapView.zoomLevel=19;
    }
    else if(distance<=125) {
        self.mapView.zoomLevel=18;
    }
    else if(distance<=250){
        self.mapView.zoomLevel=17;
    }
    else if(distance<=500){
        self.mapView.zoomLevel=16;
    }
    else if(distance<=1250){
        self.mapView.zoomLevel=15;
    }
    else if(distance<=2500){
        self.mapView.zoomLevel=14;
    }
    else if(distance<=5000){
        self.mapView.zoomLevel=13;
    }
    else if(distance<=12500){
        self.mapView.zoomLevel=12;
    }
    else if(distance<=25000){
        self.mapView.zoomLevel=11;
    }
    else if(distance<=50000){
        self.mapView.zoomLevel=10;
    }
    else{
        self.mapView.zoomLevel=9;
    }
    
}
//完成接口

- (void)payCashAction:(id)sender
{
    //现金支付跳转下单页面  (有没有接口啊??)
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    //    [alert show];
    //    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    //
    //
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    
    [LoadIndicator addIndicatorInView:self.view];
    
    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!cashPay.action?";
    
    NSMutableDictionary  *dic=[NSMutableDictionary dictionary];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    dic[@"ordeId"]=self.ordersId;
    dic[@"money"]=[NSString stringWithFormat:@"%d",5];
    dic[@"custId"]=[user objectForKey:@"userId"];
    dic[@"pway"]=@"2";
    dic[@"coupId"]=@"-1";
    
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        
        if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付完成" message:@"快跑兄弟感谢支持" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            
            
         
            
            
        }
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        [LoadIndicator stopAnimationInView:self.view];
        
        
    }];
    
    
    
}


@end
