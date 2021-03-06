//
//  RechargeViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"
#import "RechargeView.h"
@interface RechargeViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) RechargeView *rechargeView;

@property (nonatomic, strong) UIButton *weixin;

@property (nonatomic, strong) UIButton *zhifubao;

@property (nonatomic, strong) UIButton *yinhang;

@property (nonatomic, strong) NSString *money;

@property (nonatomic) BOOL is100;

@property (nonatomic) BOOL is50;

@property (nonatomic) BOOL isPresent;



/**
 *  微信支付
 */
- (void)weixinAction:(id)sender;

/**
 *  支付宝支付
 */
- (void)zhifubaoAction:(id)sender;

/**
 *  银行卡支付
 */
- (void)yinhangAction:(id)sender;

/**
 *  按钮点击
 */
- (void)buttonClick:(UIButton *)button;
@end
