//
//  LoginViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "GlobalMacro.h"
#import "FindViewController.h"
#import "RegistViewController.h"
#import "Singleton.h"
#import "FindViewController.h"
#import "CustomLoginView.h"
#import "NetworkRequest.h"
#import "URLMacro.h"
#import "RegistViewController.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "GlobalMethod.h"
#import "APService.h"
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@interface LoginViewController()<UITabBarControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alert;


@end

@implementation LoginViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userName = NO;
        self.password = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.login = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.login createLoginView];
    [self.view addSubview:self.login];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    
    [self.login.login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.login.forget addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.login.regist addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.login.userName.field.delegate = self;
    self.login.userName.field.tag = 100;
    self.login.password.field.delegate = self;
    self.login.password.field.tag = 101;
}

/**
 *  登录
 */
- (void)loginAction:(id)sender
{
    
    [self.view endEditing:YES];
    
    if ([self.login.password.field.text isEqualToString:@""] || self.login.password.field.text == nil || [self.login.userName.field.text isEqualToString:@""] || self.login.userName.field.text == nil ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }
    else
    {
        
        [self showHudInView:self.view hint:@"正在登录..."];
        
        
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setValue:self.login.userName.field.text forKey:@"mobileNo"];
        NSString *pass = [GlobalMethod md5:self.login.password.field.text];
        [para setValue:pass forKey:@"password"];
        [para setValue:@"2" forKey:@"type"];
        [para setValue:@"0" forKey:@"nickName"];
        [para setValue:@"0" forKey:@"sex"];
        [para setValue:@"0" forKey:@"address"];
        [para setValue:@"0" forKey:@"headImg"];
        [NetworkRequest netWorkRequestPOSTWithString:POST_LOGIN_REGIST_FORGET Parameters:para ResponseBlock:^(id result) {
            NSLog(@"%@", result);
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:self.login.userName.field.text forKey:@"mobileNo"];
            NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
            NSString *head=[dic objectForKey:@"headImg"];
            [user setObject:head forKey:@"headImg"];
            [self notice:result];
        } ErrorBlock:^(id error) {
            NSLog(@"%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败, 请重新登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            [self hideHud];
        }];

    }
}



/**
 *  根据result显示结果
 *
 *  @param result
 */
- (void)notice:(id)result
{
    NSDictionary * dic = (NSDictionary *)result;
    NSLog(@"%@ >>>>>>", result);
    NSArray *dataArray = [dic objectForKey:@"msg"];
    NSDictionary *myDic = [dataArray firstObject];
    if ([[myDic objectForKey:@"mobileNo"] isEqualToString:@"1"] && [[myDic objectForKey:@"password"] isEqualToString:@"1"]) {
        //保存用户id
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:[myDic objectForKey:@"id"] forKey:@"userId"];

        if ([[myDic objectForKey:@"online"] isEqualToString:@"0"]) {
            
            Singleton *share = [Singleton shareInstance];
            
            //创建标签试图控制器
            UITabBarController *tab = [[UITabBarController alloc] init];
            tab.delegate = self;
            //字
            tab.tabBar.tintColor = Green;
            //tab
            tab.tabBar.barTintColor = TabGray;
            
            tab.viewControllers = share.myTabArray;
            [self hideHud];
            [self presentViewController:tab animated:YES completion:nil];
              [user setValue:[myDic objectForKey:@"tagId"] forKey:@"tagId"];
            
            //绑定id
            [APService setTags:[NSSet setWithObjects:[myDic objectForKey:@"tagId"], nil] alias:nil callbackSelector:nil object:nil];
            
//            [self timerStart];

        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"已有账号登陆,是否强制登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag=99;
            [alert show];
            
        }
        
       
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self hideHud];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }
    
}

/**
 *  提示
 *
 *  @return
 */
- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


/**
 *  忘记密码
 */

- (void)forgetAction:(id)sender
{
    FindViewController *find = [[FindViewController alloc] init];
    [self.navigationController pushViewController:find animated:YES];
}

/**
 *  注册
 */

- (void)registAction:(id)sender
{
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}


/**
 *  mb 登录进程加载
 *
 *  @param HUD
 */

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  显示
 *
 *  @param view
 *  @param hint  (加载显示的内容)
 */
- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

/**
 *  停止hud
 */
- (void)hideHud{
    [[self HUD] hide:YES];
}

/**
 *  tabbar delegate
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

#pragma mark - 输入时键盘弹出
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {

        if (iPhone6) {
            [UIView animateWithDuration:0.3 animations:^{
                self.login.frame = CGRectMake(0, - 80, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.userName = YES;
                self.password = NO;
            }];
            
        }
        
        if (iPhone5) {
            [UIView animateWithDuration:0.3 animations:^{
                self.login.frame = CGRectMake(0, - 70, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.userName = YES;
                self.password = NO;
            }];
        }
        
        if (iPhone4) {
            [UIView animateWithDuration:0.3 animations:^{
                self.login.frame = CGRectMake(0, - 35, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.userName = YES;
                self.password = NO;
            }];
        }
        
    }

    if (textField.tag == 101) {
        if (iPhone6) {
            [UIView animateWithDuration:0.3 animations:^{
                self.login.frame = CGRectMake(0, - 110, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.userName = NO;
                self.password = YES;
            }];
            
        }
        
        if (iPhone5) {
            [UIView animateWithDuration:0.3 animations:^{
                self.login.frame = CGRectMake(0, - 80, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.userName = NO;
                self.password = YES;
            }];
            
        }
        
        if (iPhone4) {
            [UIView animateWithDuration:0.3 animations:^{
                self.login.frame = CGRectMake(0, - 50, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.userName = NO;
                self.password = YES;
            }];
            
        }

    }
  
}

//编辑结束, 键盘回收代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.login.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.userName = NO;
        self.password = NO;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//提示框代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==99) {
        switch (buttonIndex) {
            case 0:
            {
                
                [self LoginOnline];

                break;
                
            }
               
            case 1:
            {
                [self hideHud];
                break;
                
            }
   
            default:
                break;
        }
    }
    
    
    if (alertView.tag==100) {
        
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNac = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNac animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logout"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        Singleton *share=[Singleton shareInstance];
        [share.timer invalidate];
        
        
        
    }

}

//强制登陆
- (void)LoginOnline{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [GlobalMethod paramatersForValues:@[[user objectForKey:@"userId"],@"1"] keys:@"id,type"];
    [NetworkRequest netWorkRequestPOSTWithString:@"http://123.57.222.175:8080/runfast/UsersAction!usersOnlineStatus.action?" Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"results = %@", result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
            Singleton *share = [Singleton shareInstance];
            
            //创建标签试图控制器
            UITabBarController *tab = [[UITabBarController alloc] init];
            tab.delegate = self;
            //字
            tab.tabBar.tintColor = Green;
            //tab
            tab.tabBar.barTintColor = TabGray;
            
            tab.viewControllers = share.myTabArray;
            [self hideHud];
            [self presentViewController:tab animated:YES completion:nil];
            
//            //保存用户id
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setValue:[user objectForKey:@"userId"] forKey:@"userId"];
            
            [user setObject:[dic objectForKey:@"tagId"] forKey:@"tagId"];
            //绑定id
            [APService setTags:[NSSet setWithObjects:[user objectForKey:@"tagId"], nil] alias:nil callbackSelector:nil object:nil];
//            [self timerStart];

            
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"error");
    }];

}

//- (void)timerStart{
//    
//    Singleton *share = [Singleton shareInstance];
//    share.timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(isLogin:) userInfo:nil repeats:YES];;
//    [share.timer fire];
//}

- (void)isLogin:(id)sender{
    
    
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
            self.alert=[[UIAlertView alloc]initWithTitle:@"账号在异地登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            self.alert.tag=100;
            [self.alert show];
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@",error);
    }];
    
    
}



@end
