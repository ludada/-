//
//  PayViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PayViewController.h"
#import "OrderInfo.h"
#import "UIView+Frame.h"
#import "GlobalMacro.h"
#import "PayTicket.h"
#import "URLMacro.h"
#import "Order.h"
#import "PayModel.h"
#import "NetworkRequest.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PersonalViewController.h"
#import "LoadIndicator.h"
#import "RechargeViewController.h"

#define LabelHeight 50

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) OrderInfo *orderInfo;

@property (nonatomic, strong) PayTicket *payTicket;

@property (nonatomic, strong) UIButton *cashPay;

@property (nonatomic, strong) UIButton *aliPay;

@property (nonatomic, strong) UIButton *weChatPay;

@property (nonatomic, strong) UIButton *goldPay;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) BOOL isCheck;

@property (nonatomic, strong) NSMutableArray *tickeArray;

@property (nonatomic, strong) NSString *ticketId;

@property (nonatomic, strong) NSString *money;

@property (nonatomic, strong) NSString *myCoin;

//计算的金币
@property (nonatomic, assign) NSInteger calculate;

@end

@implementation PayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isCheck=NO;
        self.backButton = YES;
        self.tickeArray=[NSMutableArray array];
        self.ticketId=@"-1";
        self.calculate = 5;
    }
    return self;
    
}

- (void)loadView{
    
    [super loadView];
    
    //订单信息
    self.orderInfo=[[OrderInfo alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 160)];
    [self.view addSubview:self.orderInfo];
    
    
    //现金支付
    self.cashPay=[[UIButton alloc]initWithFrame:CGRectMake(self.orderInfo.x, self.orderInfo.height+70, SCREEN_WIDTH-40, LabelHeight)];
    [self.cashPay setBackgroundImage:[UIImage imageNamed:@"cashbutton"] forState:UIControlStateNormal];
    [self.cashPay addTarget:self action:@selector(payCashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cashPay];
    
    
    
    //金币支付
    self.goldPay=[[UIButton alloc]initWithFrame:CGRectMake(20, self.cashPay.y+self.cashPay.height+5, SCREEN_WIDTH-40, LabelHeight)];
    [self.goldPay addTarget:self action:@selector(coinPay) forControlEvents:UIControlEventTouchUpInside];
    [self.goldPay setBackgroundImage:[UIImage imageNamed:@"goldbutton"] forState:UIControlStateNormal];
    [self.view addSubview:self.goldPay];
    
    
    
    //支付宝
    self.aliPay=[[UIButton alloc]initWithFrame:CGRectMake(20, self.goldPay.y+self.goldPay.height+5, SCREEN_WIDTH-40, LabelHeight)];
    [self.aliPay setBackgroundImage:[UIImage imageNamed:@"alipaybutton"] forState:UIControlStateNormal];
    [self.aliPay addTarget:self action:@selector(aliPayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.aliPay];
    
    
    
    //代金卷
    self.payTicket=[[PayTicket alloc]initWithFrame:CGRectMake(20, self.aliPay.y + self.aliPay.height + 5 , SCREEN_WIDTH-40, LabelHeight)];
    self.payTicket.layer.cornerRadius = 3;
    self.payTicket.layer.masksToBounds = YES;
    self.payTicket.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.payTicket.layer.borderWidth = 0.5;
    
//    [self.view addSubview:self.payTicket];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(20, self.payTicket.y+self.payTicket.height, self.payTicket.width, 120)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    [self.view addSubview:self.tableView];
    self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.tableView.layer.borderWidth = 1;
    
    self.tableView.hidden = YES;
    self.payTicket.money.hidden = YES;
    self.payTicket.moneyCount.hidden = YES;
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [LoadIndicator addIndicatorInView:self.view];
    
    self.navigationItem.title=@"订单详情";
    [self getOrderIn];
    [self.payTicket addTarget:self action:@selector(isCheckAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getAllTickets];
    
    [self getCoinNumber];
    
    
    
}

- (void)isCheckAction:(id)sender{
    
    if (self.isCheck) {
        self.tableView.hidden = YES;
        self.payTicket.money.hidden = YES;
        self.payTicket.moneyCount.hidden = YES;
        [self.payTicket setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        self.isCheck = NO;
        return;

    }
    
    
    if (self.tickeArray.count==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您还没有代金券" message:nil delegate: self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    else
    {
        self.tableView.hidden = NO;
        self.payTicket.money.hidden = NO;
        self.payTicket.moneyCount.hidden = NO;
        [self.payTicket setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        self.isCheck = YES;

    }
    
  

}

#pragma mark -tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tickeArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    PayModel *model=[self.tickeArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ 元代金券",model.points];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PayModel *model=[self.tickeArray objectAtIndex:indexPath.row];
    
    self.ticketId=model.id;
    self.money=model.points;
//    [self.payTicket.moneyCount setTitle:[NSString stringWithFormat:@"%@ 元",model.points] forState:UIControlStateNormal];
    
    [self.payTicket.moneyCount setText:[NSString stringWithFormat:@"%@ 元",model.points]];
    
    self.tableView.hidden = YES;
    self.payTicket.money.hidden = NO;
    self.payTicket.moneyCount.hidden = NO;
    [self.payTicket setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

    self.isCheck = NO;
    
    
    
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
//
- (void)aliPayAction{
    
    //金额选择
    

    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
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
    order.productName = @"快跑"; //商品标题
    
    
    
    NSString *description = [NSString stringWithFormat:@"0,1,%@,1,%@",partner,self.ticketId];
    order.productDescription = description; //商品描述, 1: type (0 和1 ,0 代表订单 ,1 代表充值), 2:tag (1 代表客户端, 2 代表服务端 ) 3:id (订单id , 充值:充值人的id) 4: 1(充值方式)
    order.amount = [NSString stringWithFormat:@"%.2ld",(long)self.calculate]; //商品价格
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
//获取订单详情

- (void)getOrderIn{
    NSString *url=@"http://123.57.222.175:8080/runfast/OrderAction!orderList.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=self.orderId;
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        
        NSLog(@"%@", result);
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        self.orderInfo.orderIdValue.text= [dic objectForKey:@"orderCode"];
        NSString *str = [NSString stringWithFormat:@"     联系人   %@   %@", [dic objectForKey:@"saleNickName"],[dic objectForKey:@"saleMobileNo"]];
        [self.orderInfo.contacts setText:str];
        self.orderInfo.addTime.text=[dic objectForKey:@"addTime"];
        self.address=[dic objectForKey:@"orderAdress"];
        
        
        
    } ErrorBlock:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        

    }];
    
    
}

//获取金币数量
- (void)getCoinNumber
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [NetworkRequest netWorkRequestPOSTWithString:POST_MY_COIN Parameters:[GlobalMethod paramatersForValues:@[[user objectForKey:@"userId"], @"1"] keys:@"id,type"] ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        
        self.myCoin = [dic objectForKey:@"pointsCount"];
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

        [LoadIndicator stopAnimationInView:self.view];
    }];
}


#pragma mark - 现金支付
- (void)payCashAction:(id)sender
{
    //现金支付跳转下单页面  (有没有接口啊??)
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert show];
//    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
//
//    
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    
    [LoadIndicator addIndicatorInView:self.view];
    
    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!cashPay.action?";
    
    NSMutableDictionary  *dic=[NSMutableDictionary dictionary];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    dic[@"ordeId"]=self.orderId;
    dic[@"money"]=[NSString stringWithFormat:@"%ld",(long)self.calculate];
    dic[@"custId"]=[user objectForKey:@"userId"];
    dic[@"pway"]=@"2";
    dic[@"coupId"]=self.ticketId;
    
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        
    NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        
    if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付完成" message:@"快跑兄弟感谢支持" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        
    }

        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        [LoadIndicator stopAnimationInView:self.view];

        
    }];
    

    
}


//金币支付
- (void)coinPay{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    if ([self.myCoin integerValue] >= self.calculate) {
        
        NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!goldPay.action?";
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        dic[@"custId"]=[user objectForKey:@"userId"];
        dic[@"money"]=[NSString stringWithFormat:@"%ld",(long)self.calculate];
        dic[@"ordeId"]=self.orderId;
        dic[@"pway"]=@"4";
        dic[@"coupId"]=self.ticketId;
        [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
            NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
            NSString *flag=[dic objectForKey:@"flag"];
            if ([flag isEqualToString:@"1"]) {
                UIAlertView *alertf=[[UIAlertView alloc]initWithTitle:@"支付完成" message:@"快跑兄弟感谢支持" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertf show];
                [self performSelector:@selector(dismissAlert:) withObject:alertf afterDelay:1.5];
            }
            
            [LoadIndicator stopAnimationInView:self.view];
            
        } ErrorBlock:^(id error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            
            [LoadIndicator stopAnimationInView:self.view];

        }];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的金币数量不够" message:@"无法支付, 请进行充值" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        
        [LoadIndicator stopAnimationInView:self.view];


    }
    
    
}

//得到所有可用代金券
- (void)getAllTickets{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    NSString *url=@"http://123.57.222.175:8080/runfast/CouponsAction!couponsList.action?";
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[user objectForKey:@"userId"];
    dic[@"type"]=@"2";
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        
        NSLog(@"%@ result",result);
        NSArray *array=[result objectForKey:@"msg"];
        for (NSDictionary *dic in array) {
            PayModel *model=[[PayModel alloc]init];
            model.id=[dic objectForKey:@"id"];
            model.points=[dic objectForKey:@"points"];
            [self.tickeArray addObject:model];
        }
        

        if (self.tickeArray.count > 0) {
            PayModel *model = [self.tickeArray objectAtIndex:0];
            self.ticketId=model.id;

            
            //计算需要支付的金额数
            NSInteger cashTicket = [model.points integerValue];
            
            self.calculate = 5 - cashTicket;
            if (5 - cashTicket > 0) {
                NSMutableString *string = [NSMutableString stringWithFormat:@"需支付:  %d元", 5 - cashTicket];
                self.orderInfo.money.attributedText = [GlobalMethod fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(6, 2) AndColor:[UIColor redColor]];
                
            }
            else
            {
                self.calculate = 0;
                NSMutableString *string = [NSMutableString stringWithFormat:@"需支付:  %d元", self.calculate];
                self.orderInfo.money.attributedText = [GlobalMethod fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(6, 2) AndColor:[UIColor redColor]];
                
            }

            [self.orderInfo.insteadCash setText:[NSString stringWithFormat:@"已抵用代金券 %@元", model.points]];


        }
        else
        {
            
            

            //计算需要支付的金额数
             NSInteger cashTicket = 0;
            self.calculate = 5 - cashTicket;
            if (5 - cashTicket > 0) {
                NSMutableString *string = [NSMutableString stringWithFormat:@"需支付:  %d元", 5 - cashTicket];
                self.orderInfo.money.attributedText = [GlobalMethod fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(6, 2) AndColor:[UIColor redColor]];
                
            }
            else
            {
                
                self.calculate = 0;
                NSMutableString *string = [NSMutableString stringWithFormat:@"需支付:  %d元", self.calculate];
                self.orderInfo.money.attributedText = [GlobalMethod fuwenbenLabel:string FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(6, 2) AndColor:[UIColor redColor]];
                
            }

        }
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        
        [LoadIndicator stopAnimationInView:self.view];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        

    }];
    
}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        if ([alert.title isEqualToString:@"您的金币数量不够"]) {
            RechargeViewController *person = [[RechargeViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:person];
            
            person.isPresent = YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        if ([alert.title isEqualToString:@"支付完成"]) {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }
}

@end
