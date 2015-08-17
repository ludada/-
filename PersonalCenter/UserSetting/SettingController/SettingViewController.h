//
//  SettingViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  设置页面

#import "BaseViewController.h"
#import "PersonalView.h"
#import "AboutRunnerViewController.h"
#import "ChangePasswordViewController.h"
@interface SettingViewController : BaseViewController

@property (nonatomic, strong) PersonalView *changePassword;

@property (nonatomic, strong) PersonalView *check;

@property (nonatomic, strong) PersonalView *about;

@property (nonatomic, strong) UIButton *exitBt;

@property (nonatomic, strong) NSString *trackViewUrl;

//修改密码
- (void)changeAction;
@end
