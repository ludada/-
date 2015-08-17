//
//  RechargeViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RechargeViewController.h"
#import "GlobalMacro.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


#define payHeight 44
@implementation RechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
        self.is50 = NO;
        self.is100 = NO;
        self.money = @"50";
    }
    return  self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"充值";
    
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    
    self.rechargeView=[[RechargeView alloc]initWithFrame:CGRectMake(20, 25, SCREEN_WIDTH-40, SCREEN_HEIGHT/5)];
    [self.rechargeView.button1 setBackgroundImage:[UIImage imageNamed:@"greenCircle"] forState:UIControlStateNormal];
    [self.rechargeView.button1 setTitle:@"50" forState:UIControlStateNormal];
    [self.rechargeView.button1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.rechargeView.button1 addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.backButton1 addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.backButton1 setTitle:@"50" forState:UIControlStateNormal];
    [self.rechargeView.label1 setTextColor:Green];
    
    [self.rechargeView.button2 setBackgroundImage:[UIImage imageNamed:@"whiteCircle"] forState:UIControlStateNormal];
    [self.rechargeView.button2 setTitle:@"100" forState:UIControlStateNormal];
    [self.rechargeView.button2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

    [self.rechargeView.label2 setTextColor:[UIColor grayColor]];
    [self.rechargeView.button2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.backButton2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeView.backButton2 setTitle:@"100" forState:UIControlStateNormal];


    [self.view addSubview:self.rechargeView];
    
    self.weixin=[[UIButton alloc]initWithFrame:CGRectMake(20, self.rechargeView.frame.size.height + self.rechargeView.frame.origin.y + 50, SCREEN_WIDTH-40, payHeight)];
    [self.weixin setBackgroundImage:[UIImage imageNamed:@"weixinzhifu"] forState:UIControlStateNormal];
    [self.weixin addTarget:self action:@selector(weixinAction:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:self.weixin];
    
    
    self.zhifubao=[[UIButton alloc]initWithFrame:CGRectMake(20, self.weixin.frame.size.height + self.weixin.frame.origin.y + 15, SCREEN_WIDTH-40, payHeight)];
    [self.zhifubao setBackgroundImage:[UIImage imageNamed:@"zhifubaozhifu"] forState:UIControlStateNormal];
    [self.zhifubao addTarget:self action:@selector(zhifubaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zhifubao];
    
    self.yinhang=[[UIButton alloc]initWithFrame:CGRectMake(20, self.zhifubao.frame.size.height + self.zhifubao.frame.origin.y  + 15, SCREEN_WIDTH-40, payHeight)];
    [self.yinhang setBackgroundImage:[UIImage imageNamed:@"yinhangkazhifu"] forState:UIControlStateNormal];
    [self.yinhang addTarget:self action:@selector(zhifubaoAction:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:self.yinhang];
    
    self.rechargeView.money.delegate=self;
    
}

- (void)backAction:(id)sender
{
    if (self.isPresent) {
        self.isPresent = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 点击文本框代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.is50 = NO;
    self.is100 = NO;
    
    [self.rechargeView.button2 setBackgroundImage:[UIImage imageNamed:@"whiteCircle"] forState:UIControlStateNormal];
    [self.rechargeView.label2 setTextColor:[UIColor grayColor]];
    
    [self.rechargeView.button1 setBackgroundImage:[UIImage imageNamed:@"whiteCircle"] forState:UIControlStateNormal];
    [self.rechargeView.label1 setTextColor:[UIColor grayColor]];
   
    
    NSLog(@"daili");
    
    
}

#pragma mark - 按钮点击事件
- (void)buttonClick1:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    
    self.rechargeView.money.text=@"";
    self.money = [NSString stringWithFormat:@"%@",button.currentTitle];
    [self.rechargeView.button1 setBackgroundImage:[UIImage imageNamed:@"greenCircle"] forState:UIControlStateNormal];
    [self.rechargeView.label1 setTextColor:Green];
    
    [self.rechargeView.button2 setBackgroundImage:[UIImage imageNamed:@"whiteCircle"] forState:UIControlStateNormal];
    [self.rechargeView.label2 setTextColor:[UIColor grayColor]];
    self.is50 = YES;
    self.is100 = NO;

    
    
}

- (void)buttonClick2:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    
    self.rechargeView.money.text=@"";
    self.money = [NSString stringWithFormat:@"%@",button.currentTitle];

    [self.rechargeView.button2 setBackgroundImage:[UIImage imageNamed:@"greenCircle"] forState:UIControlStateNormal];
    [self.rechargeView.label2 setTextColor:Green];
    
    [self.rechargeView.button1 setBackgroundImage:[UIImage imageNamed:@"whiteCircle"] forState:UIControlStateNormal];
    [self.rechargeView.label1 setTextColor:[UIColor grayColor]];

    self.is100 = YES;
    self.is50 = NO;
}

- (void)weixinAction:(id)sender{
//    NSString *money=[self getMoney];
//    NSLog(@"money %@",money);
    
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


- (void)zhifubaoAction:(id)sender{
    
    NSString *money=[self getMoney];
    NSLog(@"money %@",money);
    
    NSString *partner = @"2088911716473281";
    NSString *seller = @"15811328608@163.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKLj4WAoy18dCs+l4HWuZLKhZmB1KxBI3LpZW5HkqkjZbje5IRmmbM4kKYsQPqEhV3FHJDoznCO55Xxcj6dAIiOD2QB4dE4vHrBMGA5X4nPeXvRZMZeLReWFPYViv9zIpiUDXDf5nKXCQAtL0VPeyBmnQSGtwsXSINC0hkG6ZCS/AgMBAAECgYBbwtH4sKJ4j0zC0ygSQ07YzlF07yx2PQWTOLl8A3vmFA6h93ltELLkobyBaYJOlRDEcJY470/7VEKx/xax2lAgGTw3cEbzv3R/a2+ANTTDG16nDwqznux9TVn3CHbZtqtuOJHdtqgSqfpjgfhos8DXualnebNzt1TfCZee4cGPqQJBANfzz2MUq8wdJ8H05TlsF7CRcookzLDF6fsW2w6Dakhbipt66bJRzH6EIWUL8ZiaqW6yfGhRLNAFopGBw/RWC0sCQQDBGPpUE29yLtsB3nXFQyZLCeEZa3rX8ooM5EE7nSt28XkWYg5gjD+3LfLQ8zMij2gsgwQizS4tEp0ycPxheQ/dAkAtaPpiFlWt3S+gDHQrJ/yvR1ZzkBtuzJ9QClVT7vRpdL5nxWfg9Gxw6i3vhpxt/4/DVEru0KsArz6pJEVlWraTAkEAnyq8pXMDyUYQJsE9qKWKOg5hqvdqYfi9jJTVpJMQUdIHssiO+0x/9Ll+Tng5bUJyZ0ZzsVAZwPN3+i0iDCKjTQJBAKl36emz2tvxDTGwdRZTlyqDPY3bXp8YU3NW/eT1JSVyEXtwanyb5zM8utkpmYdjwagfSFxsgSRAQFrRIno3sIc=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"快跑充值"; //商品标题
    
    NSString *description = [NSString stringWithFormat:@"1,1,%@,1,-1", [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    order.productDescription = description; //商品描述, 1: type (0 和1 ,0 代表订单 ,1 代表充值), 2:tag (1 代表客户端, 2 代表服务端 ) 3:id (订单id , 充值:充值人的id) 4: 1(充值方式)
    order.amount = [NSString stringWithFormat:@"%@", money]; //商品价格
    order.notifyURL =  @"http://123.57.222.175:8080/runfast/UsersAction!test.action"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"FasterRunner";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }

    

    
}

- (void)yinhangAction:(id)sender{
//    NSString *money=[self getMoney];
//    NSLog(@"money %@",money);

    
}


//获取支付金额
- (NSString *)getMoney
{
    if ([self.rechargeView.money.text isEqualToString:@""]) {
        return self.money;
    } else {
        return self.rechargeView.money.text;
    }

}








- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.rechargeView.money resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}
@end
