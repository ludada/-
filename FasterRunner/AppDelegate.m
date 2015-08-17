//
//  AppDelegate.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "AppDelegate.h"
#import "RunnerViewController.h"
#import "StoreViewController.h"
#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "GlobalMacro.h"
#import "NetworkRequest.h"
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "APService.h"
#import <BaiduMapAPI/BMapKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "URLMacro.h"
#import "NotificationViewController.h"


#import <ShareSDK/ShareSDK.h>

#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "WXApi.h"
#import "WXApiObject.h"

@interface AppDelegate ()<UITabBarControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    

    /**
     *  激光推送
     */
    
    //     注册推送通知
    
   
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        NSMutableSet *categories = [NSMutableSet set];
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"identifier";
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"test2";
        action.title = @"test";
        action.activationMode = UIUserNotificationActivationModeBackground;
        action.authenticationRequired = YES;
        //YES显示为红色，NO显示为蓝色
        action.destructive = NO;
        NSArray *actions = @[ action ];
        [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
        [categories addObject:category];
        
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:categories];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    

    
    //进入启动页面
    
    if ([[user objectForKey:@"daohang"] isEqualToString:@"1"]) {
        //直接进入
        [self goToMain];
    }
    else
    {
        //进入引导页
        [self makeLunchView];
    }

    
    //注册shareSDK
    [ShareSDK registerApp:@"990ed822268b"];
    [self initializePlatform];
    
    
    /**
     配置百度地图
     */
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"3ftjPNoixc9G1cNh6bzod50j"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    return YES;
}



//引导页
- (void)makeLunchView
{
    NSArray *array = [NSArray arrayWithObjects:@"one.jpg", @"two.jpg", @"three.jpg", @"four.jpg", nil];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    scroll.contentSize = CGSizeMake(self.window.bounds.size.width * 4, self.window.frame.size.height);
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.tag = 900;
    [scroll setShowsHorizontalScrollIndicator:NO];
    [self.window addSubview:scroll];
    for (int i = 0; i< array.count; i++) {
        UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(i * self.window.frame.size.width, 0, self.window.frame.size.width, self.window.frame.size.height)];
        [image setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        
        //button点击进入
        
        if (i == array.count - 1) {
            self.button = [[UIButton alloc] initWithFrame:CGRectMake(self.window.frame.size.width - 235, self.window.frame.size.height - 90, 100, 30)];
            self.button.center = CGPointMake(self.window.center.x, self.window.frame.size.height - 50);
            [_button setImage:[UIImage imageNamed:@"ok_button"] forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(buttonAction:)forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:_button];
        }
        
        [scroll addSubview:image];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > self.window.frame.size.width * 3 + 50) {
        self.isOut = YES;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isOut) {
        [UIView animateWithDuration:1.0 animations:^{
            scrollView.alpha = 0;
        } completion:^(BOOL finished) {
            [scrollView removeFromSuperview];
            //调用root导航
            [self goToMain];
        }];
    }
}

- (void)buttonAction:(id)sender
{
    UIScrollView *scrollView = (UIScrollView *)[self.window viewWithTag:900];
    [UIView animateWithDuration:1.0 animations:^{
        scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
        [self goToMain];
    }];
}


- (void)goToMain
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"daohang"] isEqualToString:@"0"] || [user objectForKey:@"daohang"] == nil) {
        [user setObject:@"1" forKey:@"daohang"];
    }
    
    //跳转主界面
    [self showTabRootViewControllers];
    
}


//试图控制器
- (void)showTabRootViewControllers
{
    //创建标签试图控制器
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.delegate = self;
    //字
    tab.tabBar.tintColor = Green;
    //tab
    tab.tabBar.barTintColor = TabGray;
    NSMutableArray *tabArray = [NSMutableArray array];
    
    
    /**
     *  首页
     */
    RunnerViewController *runnerPage = [[RunnerViewController alloc] init];
    UINavigationController *runnerPageNav = [[UINavigationController alloc] initWithRootViewController:runnerPage];
    [tabArray addObject:runnerPageNav];
    //设置背景图片和文字
    UIImage *pageImage = [UIImage imageNamed:@"shouye1"];
    pageImage = [pageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *pageImage1 = [UIImage imageNamed:@"shouye"];
    pageImage1 = [pageImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    runnerPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:pageImage1 selectedImage:pageImage];
    
    /**
     *  商城
     */
    StoreViewController *store = [[StoreViewController alloc] init];
    UINavigationController *storeNav = [[UINavigationController alloc] initWithRootViewController:store];
    [tabArray addObject:storeNav];
    UIImage *storeImage = [UIImage imageNamed:@"Store1"];
    storeImage = [storeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *storeImage1 = [UIImage imageNamed:@"Store"];
    storeImage1 = [storeImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    store.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商圈" image:storeImage1 selectedImage:storeImage];
    
    
    /**
     *  我的
     */
    PersonalViewController *personal = [[PersonalViewController alloc] init];
    UINavigationController *personalNav = [[UINavigationController alloc] initWithRootViewController:personal];
    [tabArray addObject:personalNav];
    UIImage *personImage = [UIImage imageNamed:@"wode1"];
    personImage = [personImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *personImage1 = [UIImage imageNamed:@"wode"];
    personImage1 = [personImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personal.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:personImage1 selectedImage:personImage];
    
    /**
     *  设置根视图控制器
     */
    tab.viewControllers = tabArray;
    Singleton *share = [Singleton shareInstance];
    [share.myTabArray addObjectsFromArray:tabArray];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([user objectForKey:@"logout"] || ![user objectForKey:@"userId"]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNac = [[UINavigationController alloc] initWithRootViewController:login];
        [_window setRootViewController:loginNac];
        [user removeObjectForKey:@"logout"];
    }
    else
    {
        [_window setRootViewController:tab];
//        [self timerStart];
    }
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [image setImage:[UIImage imageNamed:@"yindaoye"]];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow(CFBridgingRetain(infoDictionary));
    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    
////    [label setText:[NSString stringWithFormat:@"v %@", app_Version]];
//    
//    label.center = CGPointMake(self.window.center.x, self.window.center.y + 30);
//    [image addSubview:label];
    [self.window addSubview:image];
    [self.window bringSubviewToFront:image];
    
    [self performSelector:@selector(dismissImage:) withObject:image afterDelay:2];
    
}

- (void)dismissImage:(UIImageView *)image
{
    if (image) {
        [UIView animateWithDuration:1.5 animations:^{
            image.alpha = 0;
        } completion:^(BOOL finished) {
            
            image.frame = CGRectMake(self.window.frame.size.width/2, self.window.frame.size.height/2, 0, 0);
        }];

    }
}


#pragma mark - 激光推送代理方法

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    
   
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    
    //推送消息保存到单例里面
    
    Singleton *share = [Singleton shareInstance];
//    [self playerSys];
    if ([[[userInfo objectForKey:@"msg"] objectForKey:@"type"] isEqualToString:@"1"])
    {
        //系统消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSTEM_INFO" object:nil userInfo:userInfo];
        share.redBall = YES;
       ;
        
        if (self.backGround) {
            self.backGround = NO;

            

            [[NSNotificationCenter defaultCenter] postNotificationName:@"PRESENT" object:nil userInfo:nil];
            

        }
        else{
            //弹出提示
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您有一条新的消息" message:@"要去看看嘛" delegate:<#(id)#> cancelButtonTitle:<#(NSString *)#> otherButtonTitles:<#(NSString *), ...#>, nil]
            
        }
        
    }
    
    if ([[[userInfo objectForKey:@"msg"] objectForKey:@"type"] isEqualToString:@"2"])
    {
        //订单
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_LIST" object:nil userInfo:userInfo];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"111");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.backGround = YES;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//打开支付宝客户端
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }
    
    return YES;
}

- (void)timerStart{
    
     Singleton *share = [Singleton shareInstance];
    share.timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(isLogin:) userInfo:nil repeats:YES];;
    [share.timer fire];
}

- (void)isLogin:(id)sender{
    
    
//    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"
                ];
    dic[@"type"]=@"1";
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"
                         ];
        if (![tagId isEqualToString:tagid]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在异地登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=100;
            [alert show];
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==100) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNac = [[UINavigationController alloc] initWithRootViewController:login];
        [_window setRootViewController:loginNac];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logout"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        Singleton *share=[Singleton shareInstance];
        
        [share.timer invalidate];


    }
}

//初始化平台
- (void)initializePlatform
{
    
    //添加QQ应用  注册网址  http://open.qq.com/
//    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx9f9f4cdfaaccfbb3"
                           wechatCls:[WXApi class]];
    
    //朋友圈
    [ShareSDK connectWeChatSessionWithAppId:@"wx9f9f4cdfaaccfbb3" appSecret:@"03ba6cdde7c811c962cbe26eb72d4abb" wechatCls:[WXApi class]];
    
    //新浪
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    
}


@end
