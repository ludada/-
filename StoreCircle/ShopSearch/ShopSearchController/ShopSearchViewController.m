//
//  ShopSearchViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-19.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "ShopSearchViewController.h"
#import "ShopSearchView.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
#import "NetworkRequest.h"
#import "StoreTableViewCell.h"
#import "StoreModel.h"
#import "URLMacro.h"
#import "StoreDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SearchBarView.h"
@interface ShopSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ShopSearchViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
        self.tableArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.shop = [[ShopSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.shop createTableView];
    self.view = self.shop;
    self.shop.tableView.delegate = self;
    self.shop.tableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shopDataInfoWithContent:@""];
    
    
    //创建搜索视图
    SearchBarView *search = [[SearchBarView alloc] initWithFrame:CGRectMake(70, 20, SCREEN_WIDTH - 100, 30) label:@"搜索商铺"];
    [self.navigationItem setTitleView:search];
    //添加搜索点击事件,监控textfield 实时输入内容
    [search.search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [search.field addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
  
}

#pragma mark - 创建搜索的点击事件
//搜索点击事件
- (void)searchAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    SearchBarView *search = (SearchBarView *)button.superview.superview;
    [search endEditing:YES];
    
    
    //调用网络请求数据方法
    [self shopDataInfoWithContent:search.field.text];
}

//输入内容时改变(监控输入内容)
- (void)textDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    if ([textField.text isEqualToString:@""]) {
        //为空时调用网络请求 获取全部数据
        [self shopDataInfoWithContent:@""];
    }
}

#pragma mark -  - - - - -  - - tableview代理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    StoreModel *model = [self.tableArray objectAtIndex:indexPath.row];
    [cell.image setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
    [cell.name setText:model.name];
    [cell.style setText:model.desc];
    [cell.address setText:model.adress];
    [cell.time setText:model.busiTime];
    [cell.phone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phone setTitle:model.phone forState:UIControlStateNormal];
    [cell.phone setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    StoreDetailViewController *detail = [[StoreDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    
    StoreModel *model = [self.tableArray objectAtIndex:indexPath.row];
    detail.storeDetailId = model.id;
}


#pragma mark - 拨打电话的点击事件
- (void)phoneAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", button.currentTitle];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}


#pragma mark -  - - - - - - - - 获取商店列表数据

- (void)shopDataInfoWithContent:(NSString *)content
{
    [LoadIndicator addIndicatorInView:self.view];

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:content forKey:@"content"];
    [para setValue:@"1" forKey:@"page"];
    [para setValue:@"1000" forKey:@"rows"];
    
    [NetworkRequest netWorkRequestPOSTWithString:POST_SHOP_SEARCH Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSMutableArray *array = [GlobalMethod arrayResults:result];
        [self.tableArray removeAllObjects];
        for (NSDictionary *dic in array) {
            StoreModel *model = [[StoreModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.tableArray addObject:model];
        }
        [self.shop.tableView reloadData];
        
        
        [LoadIndicator stopAnimationInView:self.view];
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        [LoadIndicator stopAnimationInView:self.view];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
