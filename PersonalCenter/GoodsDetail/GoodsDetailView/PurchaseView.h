//
//  PurchaseView.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"
@class CustomPurchaseView;
@interface PurchaseView : BaseView

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) CustomPurchaseView *accountCoin;

@property (nonatomic, strong) CustomPurchaseView *spendCoin;

@property (nonatomic, strong) CustomPurchaseView *address;

@property (nonatomic, strong) CustomPurchaseView *name;

@property (nonatomic, strong) CustomPurchaseView *telephone;

@property (nonatomic, strong) UIButton *certain;

@property (nonatomic, strong) UIButton *cancel;

@property (nonatomic, strong) UIButton *backView;

- (void)createPurchaseView;

@end
