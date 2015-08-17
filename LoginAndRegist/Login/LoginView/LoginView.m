//
//  LoginView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "LoginView.h"
#import "CustomLoginView.h"
#import "GlobalMacro.h"
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createLoginView
{
    
    //logo
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, 80, 80, 80)];
    [logo setImage:[UIImage imageNamed:@"icon22"]];
    [self addSubview:logo];
    
    
    //userNAME
    self.userName = [[CustomLoginView alloc] initWithFrame:CGRectMake(0, logo.frame.origin.y + logo.frame.size.height + 50, SCREEN_WIDTH, 50) image:[UIImage imageNamed:@"user"] placeHold:@"用户名"];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    self.userName.field.text=[user objectForKey:@"mobileNo"];
   // [self.userName.field setText:@"18500250010"];
    self.userName.field.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_userName];
    
    //passWord
    self.password = [[CustomLoginView alloc] initWithFrame:CGRectMake(0, _userName.frame.size.height + _userName.frame.origin.y + 10, SCREEN_WIDTH, self.userName.frame.size.height) image:[UIImage imageNamed:@"password"] placeHold:@"密码"];
   // [self.password.field setText:@"123123"];
    [self.password.field setSecureTextEntry:YES];
    [self addSubview:self.password];
    
    
    self.login = [[UIButton alloc] initWithFrame:CGRectMake(20, self.password.frame.size.height + self.password.frame.origin.y + 20, SCREEN_WIDTH - 40, self.password.frame.size.height)];
    [self.login setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [self.login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.login.layer.cornerRadius = 7;
    self.login.layer.masksToBounds = YES;
    [self.login setTitle:@"登录" forState:UIControlStateNormal];
    self.login.titleLabel.font = [UIFont systemFontOfSize:20];
    self.login.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:self.login];
    
    self.regist = [[UIButton alloc] initWithFrame:CGRectMake(20, self.login.frame.size.height + self.login.frame.origin.y + 60, SCREEN_WIDTH - 40, self.password.frame.size.height)];
    [self.regist setBackgroundImage:[UIImage imageNamed:@"Regist"] forState:UIControlStateNormal];
    [self.regist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.regist.layer.cornerRadius = 7;
    self.regist.layer.masksToBounds = YES;
    [self.regist setTitle:@"注册新用户" forState:UIControlStateNormal];
    self.regist.titleLabel.font = [UIFont systemFontOfSize:20];
    self.regist.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:self.regist];
    
    
    self.forget = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, self.login.frame.size.height + self.login.frame.origin.y + 10, 60, 40)];
    [self.forget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forget.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.forget.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [self.forget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:self.forget];
    
    
    if (iPhone5) {
        logo.frame = CGRectMake((SCREEN_WIDTH - 80)/2, 40, 80, 80);
        
        
        self.userName.frame = CGRectMake(0, logo.frame.origin.y + logo.frame.size.height + 40, SCREEN_WIDTH, 50);
        
        self.password.frame = CGRectMake(0, _userName.frame.size.height + _userName.frame.origin.y + 10, SCREEN_WIDTH, self.userName.frame.size.height);
        
        self.login.frame = CGRectMake(20, self.password.frame.size.height + self.password.frame.origin.y + 20, SCREEN_WIDTH - 40, self.password.frame.size.height);
        
        self.regist.frame = CGRectMake(20, self.login.frame.size.height + self.login.frame.origin.y + 50, SCREEN_WIDTH - 40, self.password.frame.size.height);
        
        self.forget.frame = CGRectMake(SCREEN_WIDTH - 80, self.login.frame.size.height + self.login.frame.origin.y + 5, 60, 40);
    }
    
    if (iPhone4) {
        
        logo.frame = CGRectMake((SCREEN_WIDTH - 80)/2, 20, 80, 80);
        
        
        self.userName.frame = CGRectMake(0, logo.frame.origin.y + logo.frame.size.height + 20, SCREEN_WIDTH, 50);
        
        self.password.frame = CGRectMake(0, _userName.frame.size.height + _userName.frame.origin.y + 10, SCREEN_WIDTH, self.userName.frame.size.height);
        
        self.login.frame = CGRectMake(20, self.password.frame.size.height + self.password.frame.origin.y + 20, SCREEN_WIDTH - 40, self.password.frame.size.height);
        
        self.regist.frame = CGRectMake(20, self.login.frame.size.height + self.login.frame.origin.y + 50, SCREEN_WIDTH - 40, self.password.frame.size.height);
        
        self.forget.frame = CGRectMake(SCREEN_WIDTH - 80, self.login.frame.size.height + self.login.frame.origin.y + 5, 60, 40);

    }

}

@end
