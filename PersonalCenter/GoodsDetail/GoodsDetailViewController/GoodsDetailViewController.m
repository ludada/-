//
//  GoodsDetailViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GlobalMacro.h"
#import "NetworkRequest.h"
#import "GlobalMethod.h"
#import "URLMacro.h"
#import "LoadIndicator.h"
#import "GoodsDetailModel.h"
#import "PurchaseView.h"
#import "CustomPurchaseView.h"
@interface GoodsDetailViewController()<UITextFieldDelegate>

@end

@implementation GoodsDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.goods = [[GoodsDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view = self.goods;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LoadIndicator addIndicatorInView:self.view];
    
    self.navigationItem.title = @"商品详情";
    
    //调取数据请求
    [self dataWithResourse];
}

#pragma mark - - - - 获取数据源

- (void)dataWithResourse
{
    
    NSDictionary *para = [GlobalMethod paramatersForValues:@[self.goodsId] keys:@"id"];
   
    [NetworkRequest netWorkRequestPOSTWithString:POST_GOODS_DETAIL Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@" ,result);
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        GoodsDetailModel *model = [[GoodsDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        self.goods.model = model;
        
        [self.goods.purchase addTarget:self action:@selector(purchaseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [LoadIndicator stopAnimationInView:self.view];
        
        [self.goods setTimer];
        
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        [LoadIndicator stopAnimationInView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
    }];
}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


- (void)purchaseAction:(id)sender
{
    [self myCoinsNumber];
    
}


/**
 *  获取我的金币
 */
- (void)myCoinsNumber
{
    
    //创建购买界面
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.purchase = [[PurchaseView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.purchase createPurchaseView];
    [self.purchase.certain addTarget:self action:@selector(certainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.purchase.cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //设置代理
    self.purchase.name.content.delegate = self;
    self.purchase.telephone.content.delegate = self;
    self.purchase.address.content.delegate = self;
    
    
    
    //账户余额
    self.purchase.accountCoin.coin.text = [NSString stringWithFormat:@"%@",self.coins];
    
    
    
    //商品名字
    self.purchase.title.text = self.goods.model.title;
    
    
    
    //商品价格
    self.purchase.spendCoin.coin.text = [NSString stringWithFormat:@"%@",self.goods.model.points];
    
    
    
    
    
    
    [self.purchase.backView addTarget:self action:@selector(backViewAction:) forControlEvents:UIControlEventTouchUpInside];
//
    [window addSubview:self.purchase];

}


#pragma mark - 确定购买按钮
- (void)certainAction:(id)sender
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    [self.view endEditing:YES];
    
    if ([self.purchase.address.content.text isEqualToString:@""] || self.purchase.address.content.text == nil || [self.purchase.name.content.text isEqualToString:@""] || self.purchase.name.content.text == nil || [self.purchase.telephone.content.text isEqualToString:@""] || self.purchase.telephone.content.text == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入信息不能为空" message:@"请检查后确认购买" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else if ([self.coins integerValue] >= [self.goods.model.points integerValue])
    {
        self.purchase.userInteractionEnabled = NO;
        
        [LoadIndicator addIndicatorInView:self.view];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setValue:[user objectForKey:@"userId"] forKey:@"id"];
        [para setValue:@"1" forKey:@"type"];
        [para setValue:self.goods.model.id forKey:@"coupId"];
        [para setValue:self.purchase.address.content.text forKey:@"address"];
        [para setValue:self.purchase.name.content.text forKey:@"name"];
        [para setValue:self.purchase.telephone.content.text forKey:@"phone"];
        
        [NetworkRequest netWorkRequestPOSTWithString:POST_CERTAIN_BUY Parameters:para ResponseBlock:^(id result) {
            NSLog(@"%@", result);
            if ([[[GlobalMethod dictionaryResults:result] objectForKey:@"flag"] isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            }
            [self.purchase removeFromSuperview];
            
            [LoadIndicator stopAnimationInView:self.view];
        } ErrorBlock:^(id error) {
            NSLog(@"%@", error);
            [self.purchase removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            
            [LoadIndicator stopAnimationInView:self.view];
        }];
        

    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"账户余额不足" message:@"请充值后购买" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        
    }
    
  
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (iPhone5 || iPhone6) {
        [UIView animateWithDuration:0.3 animations:^{
            self.purchase.frame = CGRectMake(0, -40, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (iPhone4) {
        [UIView animateWithDuration:0.3 animations:^{
            self.purchase.frame = CGRectMake(0, -70, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.purchase.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)backViewAction:(id)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
}

- (void)cancelAction:(id)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    [self.view endEditing:YES];
    [self.purchase removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
