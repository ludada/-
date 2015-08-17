//
//  WaitViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"

@class CustomAlertView;
@interface WaitViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *orderDic;

@property (nonatomic, strong) NSString *ordersId;

@property (nonatomic, strong) NSString *jingdu;

@property (nonatomic, strong) NSString *weidu;

@property (nonatomic, strong) CustomAlertView *myAlert;

@end
