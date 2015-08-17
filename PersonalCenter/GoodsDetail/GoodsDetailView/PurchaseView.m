//
//  PurchaseView.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PurchaseView.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
#import "CustomPurchaseView.h"
@implementation PurchaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createPurchaseView
{
    //创建背景透色视图
    self.backView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_backView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [self addSubview:_backView];
    
    
    //创建购买界面
    UIView *purchase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 220)];
    [purchase setBackgroundColor:[UIColor whiteColor]];
    purchase.layer.cornerRadius = 5;
    purchase.layer.masksToBounds = YES;
    purchase.center = self.center;
    [self.backView addSubview:purchase];
    
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, purchase.frame.size.width, 40)];
    [self.title setFont:[UIFont systemFontOfSize:17]];
    [purchase addSubview:self.title];
    
    [GlobalMethod drawLineWithFrame:CGRectMake(0, 40, purchase.frame.size.width, 0.5) inView:purchase];
    
    
    self.accountCoin = [[CustomPurchaseView alloc] initWithFrame:CGRectMake(0, self.title.frame.size.height + self.title.frame.origin.y + 10, purchase.frame.size.width, 15) label:@"账户余额" image:[UIImage imageNamed:@"coin"] content:nil coins:@""];
    [purchase addSubview:self.accountCoin];
//    
    self.spendCoin = [[CustomPurchaseView alloc] initWithFrame:CGRectMake(purchase.frame.size.width/2, self.accountCoin.frame.origin.y , self.accountCoin.frame.size.width, self.accountCoin.frame.size.height) label:@"所需金币" image:[UIImage imageNamed:@"coin"] content:nil coins:@""];
    [purchase addSubview:self.spendCoin];
    
    
    self.name = [[CustomPurchaseView alloc] initWithFrame:CGRectMake(0, self.accountCoin.frame.size.height + self.accountCoin.frame.origin.y + 10, self.accountCoin.frame.size.width, self.accountCoin.frame.size.height) label:@"姓名" image:nil content:@"请输入收货人姓名" coins:nil];
    [purchase addSubview:self.name];

    
    self.telephone = [[CustomPurchaseView alloc] initWithFrame:CGRectMake(0, self.name.frame.size.height + self.name.frame.origin.y + 10, self.name.frame.size.width, self.name.frame.size.height) label:@"电话" image:nil content:@"请输入收货人电话" coins:nil];
    [purchase addSubview:self.telephone];

    
    self.address = [[CustomPurchaseView alloc] initWithFrame:CGRectMake(0, self.telephone.frame.size.height + self.telephone.frame.origin.y  + 10, self.accountCoin.frame.size.width, self.accountCoin.frame.size.height) label:@"收货地址" image:nil content:@"请输入收货地址" coins:nil];
    [purchase addSubview:self.address];
    
    
    
    
    
    self.certain = [[UIButton alloc] initWithFrame:CGRectMake(10, self.address.frame.size.height + self.address.frame.origin.y + 30, (purchase.frame.size.width - 30)/2, 35)];
    [self.certain setTitle:@"确认购买" forState:UIControlStateNormal];
    self.certain.titleLabel.font = [UIFont systemFontOfSize:15];
    self.certain.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.certain.backgroundColor = [UIColor orangeColor];
    self.certain.layer.masksToBounds = YES;
    self.certain.layer.cornerRadius = 5;
    [self.certain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [purchase addSubview:self.certain];
    
    
    self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(self.certain.frame.origin.x  +self.certain.frame.size.width + 10, self.address.frame.size.height + self.address.frame.origin.y + 30, (purchase.frame.size.width - 30)/2, 35)];
    [self.cancel setTitle:@"取消购买" forState:UIControlStateNormal];
    self.cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    self.cancel.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.cancel.backgroundColor = [UIColor clearColor];
    self.cancel.layer.masksToBounds = YES;
    self.cancel.layer.cornerRadius = 5;
    self.cancel.layer.borderWidth = 0.5;
    self.cancel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [purchase addSubview:self.cancel];
    
    
}

@end
