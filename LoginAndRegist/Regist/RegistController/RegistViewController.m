//
//  RegistViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistView.h"
#import "GlobalMacro.h"
#import "NetworkRequest.h"
#import "URLMacro.h"
#import "RegistNextViewController.h"
#import "CustomLoginView.h"
#import "AgreementViewController.h"
@interface RegistViewController()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *checkCode;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RegistViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.regist = [[RegistView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.regist createRegistView];
    self.regist.tel.field.tag=100;
    self.regist.tel.field.delegate=self;
    
    [self.regist.getCheckNum setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Status_bar"]]];

    self.view = self.regist;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self.regist.nextStep addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.regist.AgreeWith addTarget:self action:@selector(tipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.regist.getCheckNum addTarget:self action:@selector(getCheckNum:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.regist.agreement addTarget:self action:@selector(agreementAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 *  打钩
 *
 *  @return
 */
- (void)tipAction:(id)sender
{
    if (self.regist.tip == YES) {
        [self.regist.AgreeWith setImage:nil forState:UIControlStateNormal];
        self.regist.tip = NO;
    }
    else
    {
        [self.regist.AgreeWith setImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        self.regist.tip = YES;
    }
}


#pragma mark -  协议条款页面
- (void)agreementAction:(id)sender
{
    AgreementViewController *agree = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agree animated:YES];
    
}

/**
 *  下一步
 */
- (void)nextStepAction:(id)sender
{
    [self.view endEditing:YES];

    BOOL tel = [self judgeNumber1:self.regist.tel.field.text noti:@"手机号码不正确"];
    if (tel == YES) {
        BOOL pas = [self judgeNumber:self.regist.password.field.text noti:@"密码格式不正确"];
        //添加验证码
        BOOL check = [self judgeCheck:self.checkCode noti:@"验证码不正确"];
        if (check == YES && pas == YES) {
            RegistNextViewController *next = [[RegistNextViewController alloc] init];
            next.myTel = self.regist.tel.field.text;
            next.password = self.regist.password.field.text;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
   
}

//判断手机号码
- (BOOL)judgeNumber1:(NSString *)text noti:(NSString *)title
{
    //账号
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL isUser = [phoneTest evaluateWithObject:text];
    if (isUser == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        return NO;
    }
    return YES;
    
}

//判断密码
- (BOOL)judgeNumber:(NSString *)text noti:(NSString *)title
{
    //密码(正则表达式 判断是否符合 6 到 16 位)
    NSString *Regex = @"^\\w{6,16}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    BOOL isPassword = [emailTest evaluateWithObject:text];
    if (isPassword == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        return NO;
    }
    return YES;

}

//判断验证码
- (BOOL)judgeCheck:(NSString *)text noti:(NSString *)title
{
    if (![self.checkCode isEqualToString:self.regist.checkNum.field.text]&&[self.regist.checkNum.field.text isEqualToString:@""]&&self.regist.checkNum.field.text==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        return NO;
    }
    return YES;
    
}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


//获取验证码
- (void)getCheckNum:(id)sender{
    if ([self.regist.tel.field.text isEqualToString:@""] || self.regist.tel.field.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        return;
    }
    
    [self.regist.getCheckNum setBackgroundColor:TabGray];

    self.count=60;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countLow:) userInfo:nil repeats:YES];
    
    
    NSString *url = POST_GETCHECKNUM;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"mobileNo"]=self.regist.tel.field.text;
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result===%@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        if ([[dic objectForKey:@"flag"] integerValue]==1) {
            self.checkCode=[dic objectForKey:@"code"];
            
            
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"error====%@",error);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"请重新获取" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
    }];
    
}

//倒计时
- (void)countLow:(id)sender{
    [self.regist.getCheckNum setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.count] forState:UIControlStateNormal];
    if (self.count>0) {
        self.count--;
        self.regist.getCheckNum.userInteractionEnabled=NO;
        
    } else {
        [self.regist.getCheckNum setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.regist.getCheckNum setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Status_bar"]]];
        self.regist.getCheckNum.userInteractionEnabled=YES;
    }
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"dd");
    if (textField.tag==100) {
        //[self.regist.getCheckNum setBackgroundImage:[UIImage imageNamed:@"Status_bar"] forState:UIControlStateNormal];
       ;
    }
    
}

@end
