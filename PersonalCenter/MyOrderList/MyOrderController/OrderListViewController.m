//
//  OrderListViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "UIView+Frame.h"
#import "GlobalMacro.h"
#import "URLMacro.h"
#import "NetworkRequest.h"
#import "OrderListModel.h"

@interface OrderListViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *orderArray;
@end

@implementation OrderListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.orderArray=[NSMutableArray array];
        self.backButton = YES;
    }
    return self;
    
}

- (void)loadView{
    
    [super loadView];
    self.navigationItem.title=@"我的订单";
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
     [self.tableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:@"cell1"];
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [LoadIndicator addIndicatorInView:self.view];
    
    [self getDataSource];
    
}

#pragma mark - tableView代理和数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.orderArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    OrderListModel *model=self.orderArray[indexPath.row];
    cell.orderId.text=@"订单号";
    cell.orderIdValue.text=model.orderCode;
    
    
    if ([model.type isEqualToString:@"1"]) {
        cell.type.text=@"快跑";
    }else{
        cell.type.text=@"司机";
    }
    
    cell.name.text=model.nickName;
    
    cell.time.text=@"订单时间";
    
    cell.timeValue.text=model.addTime;
    
//flag:订单状态0=下单（进行中）1=接单成功（进行中）2=完成（完成）3=取消订单（取消）
    if ([model.flag isEqualToString:@"1"]) {
        cell.state.text=@"进行中";
        [cell.state setTextColor:[UIColor orangeColor]];
    }else if ([model.flag isEqualToString:@"2"]){
        cell.state.text=@"完成";
        [cell.state setTextColor:[UIColor greenColor]];

    }else{
        cell.state.text=@"取消订单";
        [cell.state setTextColor:[UIColor grayColor]];

    }
    return cell;
}

//获取数据源
- (void)getDataSource{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *url=@"http://123.57.222.175:8080/runfast/OrderAction!orderMyList.action?";
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    [param setValue:[user objectForKey:@"userId"] forKey:@"id"];
    [param setValue:@"1" forKey:@"type"];
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:param ResponseBlock:^(id result) {
        NSDictionary *dic=result;
        NSArray *array=[dic objectForKey:@"msg"];
        for (NSDictionary *dic in array) {
            OrderListModel *model=[[OrderListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.orderArray addObject:model];
        }
        
        if (array.count==0) {
            UIImageView *img=[[UIImageView alloc]initWithFrame:self.view.bounds];
            [img setImage:[UIImage imageNamed:@"backNone"]];
            [self.view addSubview:img];
        } else {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
        NSLog(@"result %@",result);
        
        [LoadIndicator stopAnimationInView:self.view];
    } ErrorBlock:^(id error) {
        NSLog(@"error,%@",error);
        [LoadIndicator stopAnimationInView:self.view];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}












@end
