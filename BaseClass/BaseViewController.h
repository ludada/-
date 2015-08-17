//
//  BaseViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "LoadIndicator.h"
@interface BaseViewController : UIViewController

@property (nonatomic, strong) BaseView *baseView;

@property (nonatomic) BOOL backButton;

@property (nonatomic) BOOL hideTab;

+ (void)dismissAlert:(UIAlertView *)alert;

@end
