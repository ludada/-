//
//  ChangePasswordViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-29.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "GlobalMacro.h"
#import "NetworkRequest.h"
#import "NetworkRequest.h"
#import "LoginViewController.h"
#import "GlobalMethod.h"
#import "URLMacro.h"
#import "CustomLoginView.h"

@interface ChangePasswordViewController ()<UIAlertViewDelegate>

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"修改密码";
    
    self.changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.changeView];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 20)];
    label1.text=@"请输入新密码";
    [label1 setFont:[UIFont systemFontOfSize:15]];
    [self.changeView addSubview:label1];
    
    self.oPassword = [[CustomLoginView alloc] initWithFrame:CGRectMake(0, label1.frame.size.height + label1.frame.origin.y + 10, SCREEN_WIDTH, 44) image:[UIImage imageNamed:@"password"] placeHold:@"请输入新密码"];
    [self.changeView addSubview:self.oPassword];
    
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, self.oPassword.frame.size.height + self.oPassword.frame.origin.y + 10, SCREEN_WIDTH - 40, 20)];
    label2.text=@"输入确认密码";
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [self.changeView addSubview:label2];
    
    
    self.nPassword=[[CustomLoginView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height + label2.frame.origin.y + 10, SCREEN_WIDTH, 44) image:[UIImage imageNamed:@"password"] placeHold:@"输入确认密码"];
    
    [self.changeView addSubview:self.nPassword];
//    self.nPassword.field.delegate = self;
    
    
    self.button=[[UIButton alloc]initWithFrame:CGRectMake(20, self.nPassword.frame.size.height + self.nPassword.frame.origin.y + 50, SCREEN_WIDTH-40, 44)];
    [self.button setBackgroundImage:[UIImage imageNamed:@"Status_bar"] forState:UIControlStateNormal];
    [self.button.layer setCornerRadius:7];
    self.button.layer.masksToBounds = YES;
    [self.button addTarget:self action:@selector(isLogin1) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.changeView addSubview:self.button];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)changPasswordAction{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *userId=[user objectForKey:@"userId"];
    NSString *str=POST_USER_CHANGE_PASSWORD(userId,[GlobalMethod md5:self.nPassword.field.text] );
    
    if (self.nPassword.field.text == nil || [self.nPassword.field.text isEqualToString:@""] || [self.oPassword.field.text isEqualToString:@""] || self.oPassword.field.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else if (![self.nPassword.field.text isEqualToString:self.oPassword.field.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码输入不一致" message:@"请确认后输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        [NetworkRequest netWorkRequestPOSTWithString:str Parameters:nil ResponseBlock:^(id result) {
            
            NSDictionary *dic = [GlobalMethod dictionaryResults:result];
            if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"nil" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            }
            
            
        } ErrorBlock:^(id error) {
            NSLog(@"faile");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出错" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        }];
    }

}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        if ([alert.title isEqualToString:@"修改成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - 键盘显示， 界面调整
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.changeView.frame = CGRectMake(0, - 130, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.changeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
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
        [self changPasswordAction];
        
    } ErrorBlock:^(id error) {
        
        
        
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


@end
