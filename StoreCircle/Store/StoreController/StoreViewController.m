//
//  StoreViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreViewController.h"
#import "NetworkRequest.h"
#import "GlobalMacro.h"
#import "StoreTableViewCell.h"
#import "StoreView.h"
#import "StoreModel.h"
#import "URLMacro.h"
#import "StoreDetailViewController.h"
#import "picModel.h"
#import "TypeModle.h"
#import "StoreModel.h"
#import "UIImageView+WebCache.h"
#import "ShopSearchViewController.h"
#import "LoadIndicator.h"
#import "NotificationViewController.h"
@interface StoreViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation StoreViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.store = [[StoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.store createStoreView];
    self.view = self.store;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //推送系统通知跳转页面
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAction:) name:@"PRESENT" object:nil];

    self.navigationItem.title = @"商圈";
    
    UIImage *image = [UIImage imageNamed:@"searchbutton"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    
    
    //获取数据
    [self getPicData];
    [self getTypeListData];
}

#pragma mark - 搜索点击事件
- (void)searchAction:(id)sender
{
    ShopSearchViewController *shop = [[ShopSearchViewController alloc] init];
    [self.navigationController pushViewController:shop animated:YES];
}



//五个button的点击事件
- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    for (UIButton *myButton in self.store.buttonArray) {
        if (myButton != button) {
            [myButton setBackgroundColor:[UIColor clearColor]];
        }
    }

    self.store.myView1.userInteractionEnabled = NO;

    TypeModle *model = [self.store.typeArray objectAtIndex:button.tag - 100];
    [self getListData:model.id];
    

    
}

#pragma mark - tableview的代理方法 _  _ - - _ _ -- _ _ _ _ - -  - -


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
    cell.phone.tag = indexPath.row + 10;
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
 

#pragma mark - - - - - - - - 数据获取 - - - - - - - - - - - - - - -


/**
 *  获取广告图片数据, 加载完成后 开启定时器
 */
- (void)getPicData
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:@"2" forKey:@"type"];

    [LoadIndicator addIndicatorInView:self.view];

    NSString *url = @"http://123.57.222.175:8080/runfast/GraphicAction!graphicGuidePage.action?";

    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:para ResponseBlock:^(id result) {
        
        NSMutableArray *array = [GlobalMethod arrayResults:result];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *myDic in array) {
            picModel *model = [[picModel alloc] init];
            [model setValuesForKeysWithDictionary:myDic];
            [dataArray addObject:model];
        }
        self.store.picArray = [NSMutableArray arrayWithArray:dataArray];
        [self.store setTimer];
        
        //创建图片视图之后 赋值button点击事件
        for (int i = 0; i < self.store.picArray.count; i++) {
            UIButton *button = (UIButton *)[self.store.scroll viewWithTag:20 + i];
            [button addTarget:self action:@selector(bannerAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [LoadIndicator stopAnimationInView:self.view];
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

#pragma mark - 顶部banner的点击事件
- (void)bannerAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    
    //跳转界面  获取链接 根据tag;
}



/**
 *  需要先获取商圈id 然后在获取商圈列表
 */

#pragma mark - 获取商圈类型列表
- (void)getTypeListData
{
    
    
    [NetworkRequest netWorkRequestGetWithString:GET_STORE_TYPE ResponseBlock:^(id result) {
        NSMutableArray *array = [GlobalMethod arrayResults:result];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *myDic in array) {
            TypeModle *model = [[TypeModle alloc] init];
            [model setValuesForKeysWithDictionary:myDic];
            [dataArray addObject:model];
        }
        self.store.typeArray = [NSMutableArray arrayWithArray:dataArray];
        self.store.tableView.delegate = self;
        self.store.tableView.dataSource = self;
        
        
        //类目栏的点击事件
        for (int i = 0; i < 5; i++) {
            UIButton *button = (UIButton *)[self.store viewWithTag:100 + i];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }


        //调取列表数据
        TypeModle *model = [self.store.typeArray firstObject];
        [self getListData:model.id];

    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        self.store.myView1.userInteractionEnabled = YES;

    }];
}


#pragma mark - 根据类型获取商圈列表

- (void)getListData:(NSString *)typeId
{
    [LoadIndicator addIndicatorInView:self.view];

    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:typeId forKey:@"id"];
    [para setValue:@"1" forKey:@"page"];
    [para setValue:@"1000" forKey:@"rows"];
    NSString *url=@"http://123.57.222.175:8080/runfast/BusinessStoreAction!businessStoreList.action?";
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSMutableArray * array = [GlobalMethod arrayResults:result];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *myDic in array) {
            StoreModel *model = [[StoreModel alloc] init];
            [model setValuesForKeysWithDictionary:myDic];
            [dataArray addObject:model];
        }
        self.tableArray = dataArray;
        [self.store.tableView reloadData];
        
        [LoadIndicator stopAnimationInView:self.view];
        self.store.myView1.userInteractionEnabled = YES;


    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        [LoadIndicator stopAnimationInView:self.view];
        self.store.myView1.userInteractionEnabled = YES;


    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.hideTab = NO;
}


- (void)presentAction:(NSNotification *)notification
{
    NotificationViewController *noti = [[NotificationViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noti];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
