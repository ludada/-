//
//  AnswerViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "AnswerViewController.h"
#import "PayView.h"
#import "PayOrder.h"
#import "PayViewController.h"
#import "PayFinish.h"
#import "GlobalMacro.h"

@interface AnswerViewController ()
@property (nonatomic, strong) PayView *payView;

@property (nonatomic, strong) PayOrder *payOrder;

@property (nonatomic, strong) PayFinish *payFinish;

@end


@implementation AnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
//    self.payView=[[PayView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/9)];
//    [self.payView.headImg setImage:[UIImage imageNamed:@"dachea"]];
//    [self.payView.name setText:@"张三"];
//    [self.payView.carId setText:@"京A56000"];
//    [self.view addSubview:self.payView];
//    
//    self.payOrder=[[PayOrder alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT/9, SCREEN_WIDTH-40, SCREEN_WIDTH/9)];
//    self.payOrder.label1.text=@"完成订单，奖励20金币";
//    self.payOrder.label2.text=@"点击前往积分商城兑换好礼";
//    [self.view addSubview:self.payOrder];
//    
//    self.payFinish=[[PayFinish alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*3/5, SCREEN_WIDTH, SCREEN_HEIGHT/10)];
//    [self.view addSubview:self.payFinish];
//    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPayOrder:)];
//    tap.numberOfTapsRequired=1;
//    [self.payView addGestureRecognizer:tap];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"快跑兄弟";
    
    //    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:nil target:self action:@selector(cancelOrder:)];
    //    self.navigationItem.rightBarButtonItem=right;
    
    
    [self.payFinish.pay addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)cancelPayOrder:(id)sender{
    
    [self.payOrder removeFromSuperview];
}

- (void)payAction:(id)sender{
    PayViewController *pay=[[PayViewController alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
    
}

- (void)payFinishAction:(id)sender{
    
    
}


@end
