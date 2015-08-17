//
//  MyCoinViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  我的积分

#import "MyCoinViewController.h"
#import "GlobalMacro.h"
#import "URLMacro.h"
#import "RunnerStoreViewController.h"
#import "NetworkRequest.h"
#import "StoreViewController.h"
@implementation MyCoinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.backButton = YES;
    }
    
    
    return self;
}

- (void)viewDidLoad{
    
    
    [super viewDidLoad];
    
    self.navigationItem.title=@"我的金币";
    self.mainView=[[UIView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, SCREEN_HEIGHT/5)];
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    [self.mainView.layer setCornerRadius:10.0];
    self.mainView.layer.masksToBounds=YES;

    [self.view addSubview:self.mainView];
    
    
    self.coinView=[[UIImageView alloc]initWithFrame:CGRectMake(self.mainView.frame.size.width/4, SCREEN_HEIGHT/12, SCREEN_HEIGHT/35, SCREEN_HEIGHT/35)];
    [self.coinView setImage:[UIImage imageNamed:@"coin"]];
    [self.view addSubview:self.coinView];
    
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(self.mainView.frame.size.width/4+30, SCREEN_HEIGHT/12, SCREEN_WIDTH/2+40, SCREEN_HEIGHT/30)];
//    NSString *string=[NSString stringWithFormat:@"您的金币 %@ 金币",@"111"];
//    [self.label setAttributedText:[self fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:20] AndRange:NSMakeRange(4, string.length - 6) AndColor:[UIColor orangeColor]]];
    [self.view addSubview:self.label];
    
    
    self.goStore=[[UIButton alloc]initWithFrame:CGRectMake(20,SCREEN_HEIGHT/4 , SCREEN_WIDTH-40, SCREEN_HEIGHT/15)];
    [self.goStore setBackgroundImage:[UIImage imageNamed:@"Status_bar"] forState:UIControlStateNormal];
    [self.goStore.layer setCornerRadius:10.0];
    self.goStore.layer.masksToBounds=YES;
    [self.goStore setTitle:@"前往快跑商城" forState:UIControlStateNormal];
    [self.goStore addTarget:self action:@selector(goStoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goStore];
    
    
    [LoadIndicator addIndicatorInView:self.view];
    
    [self getMyCoin];
    
    
    
}


//设置不同字体颜色
-(NSMutableAttributedString *)fuwenbenLabel:(NSString *)string FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];

    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    return str;
}

- (void)getMyCoin{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *userId=[user objectForKey:@"userId"];
    NSLog(@"userId==%@",userId);
    NSString *str=POST_MY_COIN;
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"id"]=userId;
    params[@"type"]=@"1";
    
    [NetworkRequest netWorkRequestPOSTWithString:str Parameters:params ResponseBlock:^(id result) {
        NSDictionary *dic=result;
        NSLog(@"%@ dic",dic);
        NSDictionary *dict=[[dic objectForKey:@"msg"]lastObject];
        NSString *pointsCount=[dict objectForKey:@"pointsCount"];
        
        NSString *string=[NSString stringWithFormat:@"您的金币 %@ 金币",pointsCount];
        
        [self.label setAttributedText:[self fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:20] AndRange:NSMakeRange(4, string.length - 6) AndColor:[UIColor orangeColor]]];

        [self.label setAttributedText:[self fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:20] AndRange:NSMakeRange(4, string.length - 6) AndColor:[UIColor orangeColor]]];

        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        NSLog(@"faile");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        [LoadIndicator stopAnimationInView:self.view];

    }];

    
}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

#pragma mark - 前往快跑商城
- (void)goStoreAction:(id)sender
{
    RunnerStoreViewController *store = [[RunnerStoreViewController alloc] init];
    [self.navigationController pushViewController:store animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}








@end


