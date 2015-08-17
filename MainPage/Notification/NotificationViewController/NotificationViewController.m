//
//  NotificationViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/5/28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "NotificationViewController.h"
#import "Notification1TableViewCell.h"
#import "NotificationModel.h"
#import "NetworkRequest.h"
#import "LoginViewController.h"
#import "Notification2TableViewCell.h"
#import "GlobalMacro.h"
#import "LoadIndicator.h"
#import "GlobalMethod.h"
#import "URLMacro.h"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton=YES;
        self.messageArray=[NSMutableArray array];
        self.isNotification = NO;
    }
    return self;
    
}

- (void)loadView{
    [super loadView];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT-64)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[Notification1TableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[Notification2TableViewCell class] forCellReuseIdentifier:@"cell2"];
//    [self.view addSubview:self.tableView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"消息";
    UIImage *img=[UIImage imageNamed:@"qingkong"];
    img=[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(isLogin3)];
    
    [LoadIndicator addIndicatorInView:self.view];
    
    
    if (self.isNotification) {
        UIImage *image = [UIImage imageNamed:@"back"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backActions1:)];

    }
    [self getDataSource];
}

//点击推送跳转
- (void)backActions1:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hideTab=YES;
}


#pragma mark- tableview 的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NotificationModel *model=[self.messageArray objectAtIndex:indexPath.row];
    
    if([model.flag isEqualToString:@"1"]){
        Notification1TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.content.text=model.content;
        cell.time.text=model.addTime;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        
        Notification2TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.content.text=model.content;
        cell.time.text=model.addTime;
        if ([model.tag isEqualToString:@"0"]) {
//            [cell.button setBackgroundColor:[GlobalMethod hexStringToColor:@"#32cd32"]];
            [cell.button setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
            [cell.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(isLogin2:) forControlEvents:UIControlEventTouchUpInside];
            cell.button.tag=indexPath.row+100;
            [cell.button setTitle:@"领取" forState:UIControlStateNormal];
        }
        else{
            [cell.button setBackgroundColor:BackGray];
            [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [cell.button setTitle:@"已领取" forState:UIControlStateNormal];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}


#pragma mark- 获取数据源
- (void)getDataSource
{
    NSString *url =@"http://123.57.222.175:8080/runfast/MessagesAction!messagesList.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    dic[@"type"]=@"1";
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"%@",result);
        NSArray *array=[result objectForKey:@"msg"];
        for (NSDictionary *dic in array) {
            NotificationModel *model=[[NotificationModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.messageArray addObject:model];
        }
        if (array.count==0) {
            UIImageView *img=[[UIImageView alloc]initWithFrame:self.view.bounds];
            [img setImage:[UIImage imageNamed:@"backNone"]];
            [self.view addSubview:img];
        } else {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@",error);
        
        [LoadIndicator stopAnimationInView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出错" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];

        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

    }];
    
    
    
}

//清空消息
- (void)removeAllMessage:(id)sender{
    if (self.messageArray.count>0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您确认要清空消息吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag=100;
        [alert show];

    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"消息列表为空" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag==100) {
        
        switch (buttonIndex) {
            case 0:{
                [self removeAll];
                break;
            }
            case 1:{
                break;
            }
            default:
                break;
        }

        
    }
    
    if (alertView.tag==111) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user setObject:@"logout" forKey:@"logout"];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }

    
}

//清空消息接口
- (void)removeAll{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    self.view.userInteractionEnabled = NO;
    
    NSString *url=@"http://123.57.222.175:8080/runfast/MessagesAction!messageEmpty.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    dic[@"type"]=@"1";
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *flag=[dic objectForKey:@"flag"];
        if ([flag isEqualToString:@"1"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"消息已清空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self.messageArray removeAllObjects];
            [self.tableView reloadData];
        }
        
        self.view.userInteractionEnabled = YES;
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@",error);
        self.view.userInteractionEnabled = YES;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出错" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
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

//领取代金券
- (void)getTickets:(UIButton *) button{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    
    self.view.userInteractionEnabled = NO;

    NotificationModel *model=[self.messageArray objectAtIndex:button.tag-100];
    model.tag=@"1";
    NSString *url=@"http://123.57.222.175:8080/runfast/CouponsRecordAction!couponsRecordAdd.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"coupId"]=model.msgId;
    dic[@"custId"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result====%@",result);
        
        [LoadIndicator stopAnimationInView:self.view];
        
        self.view.userInteractionEnabled = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"领取成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

        [self.tableView reloadData];
        
    } ErrorBlock:^(id error) {
        
        self.view.userInteractionEnabled = YES;
        
        NSLog(@"=====error%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出错" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

    }];
    
}


- (void)isLogin1{
    
//    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self getDataSource];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}


- (void)isLogin2:(UIButton *)button{
    
//    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self getTickets:button];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

- (void)isLogin3{
    
//    NSString *url=@"http://123.57.222.175:8080/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self removeAllMessage:nil];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}


@end
