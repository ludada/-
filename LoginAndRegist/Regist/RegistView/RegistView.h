//
//  RegistView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"
@class CustomLoginView;
@interface RegistView : BaseView

@property (nonatomic, strong) CustomLoginView *tel;

@property (nonatomic, strong) CustomLoginView *checkNum;

@property (nonatomic, strong) CustomLoginView *password;

@property (nonatomic, strong) UIButton *AgreeWith;

@property (nonatomic, strong) UIButton *nextStep;

@property (nonatomic, strong) UIButton *getCheckNum;

@property (nonatomic, strong) UIButton *agreement;

@property (nonatomic) BOOL tip;

- (void)createRegistView;

@end
