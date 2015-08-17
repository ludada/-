//
//  CustomAlertView.h
//  Test
//
//  Created by HLKJ on 15/6/11.
//  Copyright (c) 2015年 com.hlkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView


@property (nonatomic, strong) UIButton *backGround;


@property (nonatomic, strong) UIButton *continueRush;

@property (nonatomic, strong) UIImageView *run;

@property (nonatomic, strong) UIButton *contactServer;

@property (nonatomic, strong) UIImageView *phone;

@property (nonatomic, strong) UIButton *cancelButton;


- (void)CreateMyCustomAlert;


@end
