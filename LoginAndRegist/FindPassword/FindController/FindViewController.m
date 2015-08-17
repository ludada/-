//
//  FindViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "FindViewController.h"
#import "FindView.h"
#import "GlobalMacro.h"
#import "CustomLoginView.h"
#import "NetworkRequest.h"
#import "URLMacro.h"
#import "GlobalMethod.h"
@interface FindViewController()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic, strong) NSString *checkCode;

@end

@implementation FindViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
        self.count=60;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.navigationItem.title = @"找回密码";
    self.find = [[FindView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.find createFindView];
    [self.find.getCheckNum setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Status_bar"]]];
    self.view = self.find;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.find.commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.find.getCheckNum addTarget:self action:@selector(getCheckNum:) forControlEvents:UIControlEventTouchUpInside];
    self.find.newsPassword.field.delegate = self;
}

- (void)commitAction:(id)sender
{
    [self.view endEditing:YES];
    BOOL pass = [self judgeNumber:self.find.newsPassword.field.text noti:@"密码格式不正确"];
    BOOL check = [self judgeCheck:self.checkCode noti:@"验证码不正确"];
    if (pass == YES && check == YES) {
        
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setValue:self.find.telephone.field.text forKey:@"mobileNo"];
        //密码加密
        NSString *passmd = [GlobalMethod md5:self.find.newsPassword.field.text];
        [para setValue:passmd forKey:@"password"];
        [para setValue:@"3" forKey:@"type"];
        [para setValue:@"0" forKey:@"nickName"];
        [para setValue:@"0" forKey:@"sex"];
        [para setValue:@"0" forKey:@"address"];
        [para setValue:@"0" forKey:@"headImg"];
        [NetworkRequest netWorkRequestPOSTWithString:POST_LOGIN_REGIST_FORGET Parameters:para ResponseBlock:^(id result) {
            NSLog(@"%@", result);
            [self notice:result];
        } ErrorBlock:^(id error) {
            NSLog(@"%@", error);
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
    NSLog(@"%@", result);
    NSArray *dataArray = [dic objectForKey:@"msg"];
    NSDictionary *myDic = [dataArray firstObject];
    if ([[myDic objectForKey:@"mobileNo"] isEqualToString:@"1"] && [[myDic objectForKey:@"password"] isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码已找回" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }
    else
    {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码修改失败" message:@"手机或验证码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }

}
/**
 *  验证密码
 *
 *  @param text  密码
 *  @param title 提示
 *
 *  @return bool
 */
- (BOOL)judgeNumber:(NSString *)text noti:(NSString *)title
{
    //正则表达式  判断密码长度
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

/**
 *  解除alert
 *
 *  @param alert
 */
- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
    if ([alert.title isEqualToString:@"密码已找回"]) {
        [self.navigationController popViewControllerAnimated:YES];
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
        self.find.frame = CGRectMake(0, - 30, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.find.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}

//倒计时
- (void)countLow:(id)sender{
    [self.find.getCheckNum setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.count] forState:UIControlStateNormal];
    if (self.count>0) {
        self.count--;
        self.find.getCheckNum.userInteractionEnabled=NO;
        
    } else {
        [self.find.getCheckNum setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.find.getCheckNum setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Status_bar"]]];
        self.find.getCheckNum.userInteractionEnabled=YES;
    }
    
    
}

//判断验证码
- (BOOL)judgeCheck:(NSString *)text noti:(NSString *)title
{
    if (![self.checkCode isEqualToString:self.find.checkNum.field.text]&&[self.find.checkNum.field.text isEqualToString:@""]&&self.find.checkNum.field.text==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        return NO;
    }
    return YES;
    
}


//获取验证码
- (void)getCheckNum:(id)sender{
    if ([self.find.telephone.field.text isEqualToString:@""] || self.find.telephone.field.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        return;
    }
    
    [self.find.getCheckNum setBackgroundColor:TabGray];
    
    self.count=60;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countLow:) userInfo:nil repeats:YES];
    NSString *url=POST_GETCHECKNUM;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"mobileNo"]=self.find.telephone.field.text;
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result===%@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        if ([[dic objectForKey:@"flag"] integerValue]==1) {
            self.checkCode=[dic objectForKey:@"code"];
            
        }
        
    } ErrorBlock:^(id error) {
        NSLog(@"error====%@",error);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请重新获取" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self dismissAlert:alert];
        
    }];
    
}


@end
