//
//  SettingViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "SettingViewController.h"
#import "NetworkRequest.h"
#import "GlobalMacro.h"
#import "PayViewController.h"
#import "Singleton.h"
#import "LoginViewController.h"
#import "URLMacro.h"
#import "LoadIndicator.h"
@interface SettingViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSString *version;

@end
@implementation SettingViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    
    return self;
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.changePassword=[[PersonalView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.changePassword.label.text = @"修改密码";
    [self.changePassword.lastImg setImage:[UIImage imageNamed:@"next1"]];
    [self.changePassword.button addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changePassword];
    
//    self.check=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.changePassword.frame.size.height + self.changePassword.frame.origin.y, SCREEN_WIDTH, 44)];
//    self.check.label.text = @"检查更新";
//    [self.check.lastImg setImage:[UIImage imageNamed:@"next1"]];
//    [self.check.button addTarget:self action:@selector(isLogin5) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:self.check];
    
    self.about=[[PersonalView alloc]initWithFrame:CGRectMake(0, self.changePassword.frame.size.height + self.changePassword.frame.origin.y, SCREEN_WIDTH, 44)];
    [self.about.lastImg setImage:[UIImage imageNamed:@"next1"]];
    [self.about.button addTarget:self action:@selector(aboutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.about.label.text=@"关于快跑";
    [self.view addSubview:self.about];
    
    
    self.exitBt=[[UIButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT/2 - 50, SCREEN_WIDTH-40, 44)];
    [self.exitBt setBackgroundImage:[UIImage imageNamed:@"zhaungtai"] forState:UIControlStateNormal];
    [self.exitBt addTarget:self action:@selector(isLogin6) forControlEvents:UIControlEventTouchUpInside];
    self.exitBt.layer.cornerRadius = 7;
    self.exitBt.layer.masksToBounds = YES;
    [self.exitBt setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.view addSubview:self.exitBt];
    
    
    
}

- (void)changeAction{
    ChangePasswordViewController *change=[[ChangePasswordViewController alloc]init];
    [self.navigationController pushViewController:change animated:YES];
    
}

//退出登录
- (void)exitAction:(id)sender{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    NSString *url=@"http://123.57.222.175:8080/runfast/CustomerAction!customerExit.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *flag=[dic objectForKey:@"flag"];
        if ([flag isEqualToString:@"1"]) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            [user setObject:@"logout" forKey:@"logout"];
                    
            LoginViewController *login = [[LoginViewController alloc] init];
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:loginNav animated:YES completion:nil];

        }
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        
        [LoadIndicator stopAnimationInView:self.view];
    }];
    

}

//关于我们
- (void)aboutAction:(id)sender{
    
    AboutRunnerViewController *about=[[AboutRunnerViewController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
    
}
//版本更新
- (void)versionAction:(id)sender{
    
//    [NetworkRequest netWorkRequestGetWithString:@"http://123.57.222.175:8080/colourful/songAction!getversion.action" ResponseBlock:^(id result) {
//        NSDictionary *dic = (NSDictionary *)result;
//        NSString *latestVersion = [dic objectForKey:@"version"];
//        
//        //获取当前app版本号
//        NSDictionary *current = [[NSBundle mainBundle] infoDictionary];
//        self.version = [current objectForKey:@"CFBundleVersion"];
//        
//        double doubleCurrentVersion = [self.version doubleValue];
//        double doubleUpDateVersion = [latestVersion doubleValue];
//        
//        if (doubleCurrentVersion < doubleUpDateVersion) {
//            NSString *titleStr = [NSString stringWithFormat:@"检查更新: 快跑兄弟"];
//            NSString *msg = [NSString stringWithFormat:@"发现新版本 (%@) , 是否升级?", latestVersion];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
//            [alert show];
//            
//        }
//        else
//        {
//            NSString *titleStr = [NSString stringWithFormat:@"检查更新: 快跑兄弟"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:@"暂无新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
//
//        }
//        
//        
//    } ErrorBlock:^(id error) {
//        
//        NSLog(@"%@", error);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取数据错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
//        
//    }];
//
    
//    
//    NSString *latestVersion = @"";
//    NSError *error = nil;
//    //获取appid?
//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=999310681"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    if (error) {
//        NSLog(@"error = %@", [error description]);
//        return;
//    }
//    NSArray *resultArray = [appInfoDic objectForKey:@"results"];
//    if (![resultArray count]) {
//        NSLog(@"error: resultArray === nil");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法获取数据" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
//        [alert show];
//        alert.tag = 111;
//        
//        return;
//    }
//    NSDictionary *infoDic = [resultArray firstObject];
//    latestVersion = [infoDic objectForKey:@"version"];
//    self.trackViewUrl = [infoDic objectForKey:@"trackViewUrl"];
//    NSString *trackName = [infoDic objectForKey:@"trackName"];
//    
//    
//    NSDictionary *current = [[NSBundle mainBundle] infoDictionary];
//    self.version = [current objectForKey:@"CFBundleVersion"];
//    
//    double doubleCurrentVersion = [self.version doubleValue];
//    double doubleUpDateVersion = [latestVersion doubleValue];
//    
//    if (doubleCurrentVersion < doubleUpDateVersion) {
//        NSString *titleStr = [NSString stringWithFormat:@"检查更新: %@", trackName];
//        NSString *msg = [NSString stringWithFormat:@"发现新版本 (%@) , 是否升级?", latestVersion];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
//        alert.tag = 100;
//        [alert show];
//        
//    }
//    else
//    {
//        NSString *titleStr = [NSString stringWithFormat:@"检查更新: %@", trackName];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:@"暂无新版本" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        alert.tag = 2000;
//        [alert show];
//    }
//    
}

#pragma mark - alert代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (alertView.tag == 100) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
            }
        }
    
    
    
    if (alertView.tag==111) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user setObject:@"logout" forKey:@"logout"];
        
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }

    
}

-  (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}

- (void)isLogin6{
    
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
        [self exitAction:nil];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

//- (void)isLogin5{
//    
////    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
//    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//    dic[@"type"]=@"1";
//    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
//    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
//        
//        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
//        NSString *tagId=[dic objectForKey:@"tagId"];
//        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
//        if (![tagid isEqualToString:tagId]) {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            alert.tag=111;
//            return;
//            
//        }
//        [self versionAction:nil];
//        
//    } ErrorBlock:^(id error) {
//        
//        
//        
//    }];
//    
//    
//}




- (void)payView{
    
    PayViewController *pay=[[PayViewController alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}




@end
