//
//  LoginViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"

@class LoginView;

@interface LoginViewController : BaseViewController

@property (nonatomic, strong) LoginView *login;

@property (nonatomic) BOOL userName;

@property (nonatomic) BOOL password;


@end
