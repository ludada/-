//
//  ChangePasswordViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-29.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  修改密码页面

#import "BaseViewController.h"
@class CustomLoginView;
@interface ChangePasswordViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) CustomLoginView *oPassword;

@property (nonatomic, strong) CustomLoginView *nPassword;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *changeView;


- (void)changPasswordAction;
@end
