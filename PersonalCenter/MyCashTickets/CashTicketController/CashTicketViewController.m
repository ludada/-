//
//  CashTicketViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "CashTicketViewController.h"
#import "URLMacro.h"
#import "UIImageView+WebCache.h"
#import "CashTicketModel.h"
#import "NetworkRequest.h"
#import "GlobalMacro.h"
#import "LoadIndicator.h"


@interface CashTicketViewController ()

@property (nonatomic, strong) NSMutableArray *ticketArray;

@property (nonatomic, strong) NSMutableArray *ticketArray1;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation CashTicketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
        self.ticketArray=[NSMutableArray array];
        self.ticketArray1=[NSMutableArray array];
        self.isUse=YES;
    }
    return self;
    
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    self.navigationItem.title=@"代金券";
    
    self.noUse=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width/2-10, 35)];
    [self.noUse setBackgroundImage:[UIImage imageNamed:@"daijinquan_03"] forState:UIControlStateNormal];
    [self.noUse setTitle:@"可用代金券" forState:UIControlStateNormal];
    [self.noUse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.noUse addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.noUse];
    
    self.already=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 20, self.view.frame.size.width/2-10, 35 )];
    [self.already setBackgroundImage:[UIImage imageNamed:@"daijinquan_04"] forState:UIControlStateNormal];
    [self.already setTitle:@"已用代金券" forState:UIControlStateNormal];
    [self.already setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.already addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.already];

    self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 30+SCREEN_HEIGHT/20, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    [self.imgView setImage:[UIImage imageNamed:@"backNone"]];
    
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.noUse.frame.size.height + self.noUse.frame.origin.y + 20, SCREEN_WIDTH, SCREEN_HEIGHT - (self.noUse.frame.size.height + self.noUse.frame.origin.y + 20 + 64))];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CashTicketsTableViewCell class] forCellReuseIdentifier:@"cell1"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    

    
    [self getMyTickets];
    [self getMyNoTickets];
    
}



#pragma mark -tableview代理 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isUse) {
        return self.ticketArray.count;

    }
    else
        return self.ticketArray1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashTicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
  //  CashTicketModel *model=self.ticketArray[indexPath.row];
    if (self.isUse) {
        CashTicketModel *model=self.ticketArray[indexPath.row];
        [cell.backImg setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
        
    }
    else{
        CashTicketModel *model=self.ticketArray1[indexPath.row];
        [cell.backImg setImageWithURL:[NSURL URLWithString:model.linkUrl] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
 
    }
    return cell;
    
    
}


#pragma mark - 按钮事件
- (void)buttonClick:(UIButton *)button{
    if (self.isUse) {
        self.isUse=NO;
   
        [self.already setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.noUse setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.noUse setBackgroundImage:[UIImage imageNamed:@"daijinquan_01"] forState:UIControlStateNormal];
        
        [self.already setBackgroundImage:[UIImage imageNamed:@"daijinquan_02"] forState:UIControlStateNormal];
        [self.tableView reloadData];
        
        if (self.ticketArray1.count > 0) {
            if (self.imgView) {
                [self.imgView removeFromSuperview];
                
            }
        }
        else
        {
            [self.view addSubview:self.imgView];
        }

        
    } else {
        
        self.isUse=YES;

        [self.already setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.noUse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.noUse setBackgroundImage:[UIImage imageNamed:@"daijinquan_03"] forState:UIControlStateNormal];

        [self.already setBackgroundImage:[UIImage imageNamed:@"daijinquan_04"] forState:UIControlStateNormal];
        
        [self.tableView reloadData];
        
        
        if (self.ticketArray.count > 0) {
            if (self.imgView) {
                [self.imgView removeFromSuperview];
                
            }
        }
        else
        {
            [self.view addSubview:self.imgView];
        }
        



    }
    
}

#pragma mark- 获取可用代金券
- (void)getMyTickets{
    
    [LoadIndicator addIndicatorInView:self.view];

    
    [self.ticketArray removeAllObjects];
    NSString *str=POST_COUPONS_LIST;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    dic[@"type"]=@"2";
    [NetworkRequest netWorkRequestPOSTWithString:str Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result=====111>>>%@",result);
        NSArray *array=[result objectForKey:@"msg"];

        for (NSDictionary *dic in array) {
            
            CashTicketModel *model=[[CashTicketModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.ticketArray addObject:model];
            
        }
        if (array.count==0) {
           
            [self.view addSubview:self.imgView];
            
        }
        else{
            
            if (self.imgView) {
                [self.imgView removeFromSuperview];

            }
            
            [self.tableView reloadData];

            
        }

        
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        [LoadIndicator stopAnimationInView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
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

// 不可用代金券
- (void)getMyNoTickets{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    [self.ticketArray1 removeAllObjects];
    NSString *str=POST_COUPONS_LIST;
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    dic[@"type"]=@"1";
    [NetworkRequest netWorkRequestPOSTWithString:str Parameters:dic ResponseBlock:^(id result) {
        NSLog(@"result=====>>>%@",result);
        NSArray *array=[result objectForKey:@"msg"];

        for (NSDictionary *dic in array) {
            CashTicketModel *model=[[CashTicketModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.ticketArray1 addObject:model];
            
        }
        
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        
        [LoadIndicator stopAnimationInView:self.view];
        
        NSLog(@"error=====>>>%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        

    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}






@end
