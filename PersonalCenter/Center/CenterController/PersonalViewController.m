//
//  PersonalViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PersonalViewController.h"
#import "GlobalMacro.h"
#import "RunnerStoreViewController.h"
#import "ChangeViewController.h"
#import "CashTicketViewController.h"
#import "RechargeViewController.h"
#import "NetworkRequest.h"
#import "UIImageView+WebCache.h"
#import "OrderListViewController.h"
#import "URLMacro.h"
#import "LoginViewController.h"
#import "LoadIndicator.h"
#import "NotificationViewController.h"
#import "GlobalMethod.h"
#import "Singleton.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@interface PersonalViewController()<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *sysNoti;

@end

@implementation PersonalViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SYSTEM_INFO" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //推送系统通知跳转页面
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAction:) name:@"PRESENT" object:nil];

//    
//    //注册系统通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemNotification:) name:@"SYSTEM_INFO" object:nil];
    

    self.navigationItem.title = @"我的";

    UIImage *image = [UIImage imageNamed:@"setting"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(settingAction)];
    
    self.navigationItem.rightBarButtonItem=right;
    
    self.personalHead=[[PersonalHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/7)];
    [self.personalHead.headView addTarget:self action:@selector(infoChangeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personalHead addTarget:self action:@selector(infoChangeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *toRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, (self.personalHead.frame.size.height - 15)/2, 10, 20)];
    [toRight setImage:[UIImage imageNamed:@"next1"]];
    [self.personalHead addSubview:toRight];
    
   // [self.personalHead.headView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.personalHead];
    
    //画线
    [GlobalMethod drawLineWithFrame:CGRectMake(0, self.personalHead.frame.size.height - 0.5, SCREEN_WIDTH, 0.5) inView:self.personalHead];

    
    self.recharge=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.personalHead.frame.size.height + self.personalHead.frame.origin.y + 10, SCREEN_WIDTH, 44)];
    self.recharge.label.text=@"充值";
    [self.recharge.lastImg setImage:[UIImage imageNamed:@"next1"]];
    [self.recharge.button addTarget:self action:@selector(chargeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.recharge.headImg setImage:[UIImage imageNamed:@"recharge"]];
    [self.view addSubview:self.recharge];
    
    //画线
    [GlobalMethod drawLineWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5) inView:self.recharge];
    
    
    self.dajinquan=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.recharge.frame.origin.y + self.recharge.frame.size.height, SCREEN_WIDTH, 44)];
    [self.dajinquan.lastImg setImage:[UIImage imageNamed:@"next1"]];

    self.dajinquan.label.text=@"代金券";
    [self.dajinquan.button addTarget:self action:@selector(isLogin2) forControlEvents:UIControlEventTouchUpInside] ;
    [self.dajinquan.headImg setImage:[UIImage imageNamed:@"cashTickets"]];
    [self.view addSubview:self.dajinquan];
    
    self.myGold=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.dajinquan.frame.origin.y + self.dajinquan.frame.size.height, SCREEN_WIDTH, 44)];
    [self.myGold.lastImg setImage:[UIImage imageNamed:@"next1"]];

    [self.myGold.headImg setImage:[UIImage imageNamed:@"gold"]];
    self.myGold.label.text=@"我的金币";
    [self.myGold.button addTarget:self action:@selector(isLogin3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myGold];
    
    self.myOrder=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.myGold.frame.origin.y + self.myGold.frame.size.height, SCREEN_WIDTH, 44)];
    self.myOrder.label.text=@"我的订单";
    [self.myOrder.button addTarget:self action:@selector(isLogin4) forControlEvents:UIControlEventTouchUpInside];
    [self.myOrder.lastImg setImage:[UIImage imageNamed:@"next1"]];
    [self.myOrder.headImg setImage:[UIImage imageNamed:@"orders"]];
    
    [self.view addSubview:self.myOrder];
    
    self.store=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.myOrder.frame.origin.y + self.myOrder.frame.size.height, SCREEN_WIDTH, 44)];
    [self.store.lastImg setImage:[UIImage imageNamed:@"next1"]];
    [self.store.headImg setImage:[UIImage imageNamed:@"store"]];
    self.store.label.text=@"快跑商城";
    [self.store.button addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.store];
    
    self.systemInfo=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.store.frame.origin.y + self.store.frame.size.height + 0.5, SCREEN_WIDTH, 44)];
    [self.systemInfo.lastImg setImage:[UIImage imageNamed:@"next1"]];
    [self.systemInfo.headImg setImage:[UIImage imageNamed:@"info"]];
    self.systemInfo.label.text=@"系统消息";
    [self.systemInfo.button addTarget:self action:@selector(isLogin5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.systemInfo];
    
    
    //小红点
    self.sysNoti = [[UIImageView alloc] initWithFrame:CGRectMake(self.systemInfo.frame.size.width/3*2, (self.systemInfo.frame.size.height - 10)/2, 10, 10)];
    [self.systemInfo addSubview:self.sysNoti];
    
    
    

    
    [LoadIndicator addIndicatorInView:self.view];
    
    //获取个人资料
    [self isLogin1];
    
}

/**
 *  个人信息修改
 */
- (void)infoChangeAction{
    ChangeViewController *change=[[ChangeViewController alloc]init];
    [self.navigationController pushViewController:change animated:YES];
}

//设置

- (void)settingAction{
    
    SettingViewController *setting=[[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

/**
 *  快跑商城的点击事件
 */
- (void)storeAction:(id)sender
{
    RunnerStoreViewController *runnerStore = [[RunnerStoreViewController alloc] init];
    [self.navigationController pushViewController:runnerStore animated:YES];
    
}

//我的金币
- (void)myCoinAction{
    MyCoinViewController *coin=[[MyCoinViewController alloc]init];
    [self.navigationController pushViewController:coin animated:YES];
    
}
//代金卷
- (void)ticketsAction{
    
    CashTicketViewController *tickets=[[CashTicketViewController alloc]init];
    [self.navigationController pushViewController:tickets animated:YES];
}

//充值
- (void)chargeAction:(id)sender{
    RechargeViewController *recharge=[[RechargeViewController alloc]init];
    [self.navigationController pushViewController:recharge animated:YES]
    ;
}

//我的订单
- (void)myOrderList:(id)sender{
    OrderListViewController *order=[[OrderListViewController alloc]init];
    [self.navigationController pushViewController:order animated:YES];
    
}
//系统消息
- (void)systemInfoAction:(id)sender
{
    NotificationViewController *noti = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:noti animated:YES];
    [self.sysNoti setImage:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = NO;
    
    Singleton *share = [Singleton shareInstance];
    if (share.redBall) {
        [self.sysNoti setImage:[UIImage imageNamed:@"noti"]];
        share.redBall = NO;
    }
    
    
    
}

//获取个人资料
- (void)getPersonalInfo
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
   
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[user objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:POST_USER_INFO Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result===%@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        [self.personalHead.headView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headImg"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        self.personalHead.name.text=[dic objectForKey:@"nickName"];
        self.personalHead.phone.text=[dic objectForKey:@"mobileNo"];
        [user setObject:[dic objectForKey:@"headImg"] forKey:@"headImg"];
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        NSLog(@"error===%@",error);
        [LoadIndicator stopAnimationInView:self.view];

    }];
    
    
}



- (void)isLogin1{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        
        [self getPersonalInfo];
        
    } ErrorBlock:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
//        [GlobalMethod dismissAlert:alert];
        
        
    }];
    
    
}

- (void)isLogin2{
    
//    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self ticketsAction];
        
    } ErrorBlock:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        

        
    }];
    
    
}

- (void)isLogin3{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self myCoinAction];
        
    } ErrorBlock:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        

        
    }];
    
    
}

- (void)isLogin4{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self myOrderList:nil];
        
    } ErrorBlock:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        

        
    }];
    
    
}

- (void)isLogin5{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self systemInfoAction:nil];
        
    } ErrorBlock:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
//        [GlobalMethod dismissAlert:alert];
        

        
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


#pragma mark - 通知系统消息

- (void)systemNotification:(NSNotification *)notification
{
//    NotificationViewController *noti = [[NotificationViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noti];
//    
//    [self presentViewController:nav animated:YES completion:nil];
    
//    
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    
    [self.sysNoti setImage:[UIImage imageNamed:@"noti"]];
    
    
    
}


@end
