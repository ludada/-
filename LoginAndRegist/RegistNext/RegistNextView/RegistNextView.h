//
//  RegistNextView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"
@class CustomLoginView;
@interface RegistNextView : BaseView

@property (nonatomic, strong) UIButton *headImg;

@property (nonatomic, strong) UISegmentedControl *segControl;

@property (nonatomic, strong) CustomLoginView *nickName;

@property (nonatomic, strong) CustomLoginView *address;

@property (nonatomic, strong) UIButton *go;


@property (nonatomic, strong) UIButton *regionButton;

- (void)createRegistNextView;


@end
