//
//  RunnerStoreViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RunnerStoreViewController.h"
#import "RunnerStoreView.h"
#import "GlobalMacro.h"
#import "NetworkRequest.h"
#import "CustomItemButton.h"
#import "URLMacro.h"
#import "picModel.h"
#import "RunnerStoreModel.h"
#import "RunnerStoreCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "RunnerRecommendCollectionViewCell.h"
#import "GoodsDetailViewController.h"
#import "LoadIndicator.h"
#import "StoreSearchViewController.h"
#import "GetCoinViewController.h"
@interface RunnerStoreViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation RunnerStoreViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.collectArray = [NSMutableArray array];
        self.backButton = YES;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    self.runnerStore = [[RunnerStoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view = self.runnerStore;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"快跑商城";
    
    UIImage *image = [UIImage imageNamed:@"searchbutton"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    
    
    //调用数据获取 并创建界面
    [self runnerStoreAdvertisement];
    
   
}

- (void)searchAction:(id)sender
{
    [self.view endEditing:YES];
    StoreSearchViewController *search = [[StoreSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)buttonAction:(id)sender
{

//    self.view.userInteractionEnabled = NO;
    CustomItemButton *button = (CustomItemButton *)sender;
    if (button.tag == 110) {
        //精品购物
        [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [self.runnerStore.localLife setBackgroundColor:[UIColor clearColor]];

        [self getDataSourse:@"2"];
        
        
    }
    else
    {
        //本地生活
        [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [self.runnerStore.shopping setBackgroundColor:[UIColor clearColor]];
        [self getDataSourse:@"1"];
    }
    
    
   
}


#pragma mark - CollectionView代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RunnerStoreModel *model = [self.collectArray objectAtIndex:indexPath.row];
    //不是推荐商品
    if ([model.recommend integerValue] == 0) {
        RunnerStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        
        [cell.image setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
        [cell.title setText:model.title];
        [cell.coin setText:[NSString stringWithFormat:@"%@", model.points]];
        
        return cell;
    }
    else {
        
        RunnerRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.image setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
        [cell.title setText:model.title];
        [cell.coin setText:[NSString stringWithFormat:@"%@", model.points]];
        return cell;
    }
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RunnerStoreModel *model = [self.collectArray objectAtIndex:indexPath.row];
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    [self.navigationController pushViewController:goods animated:YES];
    goods.goodsId = model.id;
    goods.coins = model.pointsCount;
}




#pragma mark - 快跑商城广告位
- (void)runnerStoreAdvertisement
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:@"3" forKey:@"type"];
    [NetworkRequest netWorkRequestPOSTWithString:POST_ADVERTISE Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSMutableArray *array = [GlobalMethod arrayResults:result];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            picModel *model = [[picModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        self.runnerStore.picArray = dataArray;
        [self.runnerStore setTimer];
        
               //获取金币数量
        [self myCoinsNumber];
        
       

    } ErrorBlock:^(id error) {
        NSLog(@"%@" , error);
        [LoadIndicator stopAnimationInView:self.view];

    }];
}
#pragma mark - 赚取金币的点击事件
- (void)howAction:(id)sender
{
    [NetworkRequest netWorkRequestGetWithString:@"http://123.57.222.175:8080/runfast/UsersAction!usersHowGold.action" ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        
        GetCoinViewController *coin = [[GetCoinViewController alloc] init];
        
        [self.navigationController pushViewController:coin animated:YES];
        
        coin.getCoinUrl = [dic objectForKey:@"path"];
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
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


- (void)myCoinsNumber
{
    NSString *userId = [GlobalMethod UserId];
    NSDictionary *para = [GlobalMethod paramatersForValues:@[userId, @"1"]  keys:@"id,type"];
    [NetworkRequest netWorkRequestPOSTWithString:POST_MY_COIN Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        self.runnerStore.myCoin = [dic objectForKey:@"pointsCount"];
        
        //如何赚取金币的点击事件
        [self.runnerStore.how addTarget:self action:@selector(howAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.runnerStore.getCoin addTarget:self action:@selector(howAction:) forControlEvents:UIControlEventTouchUpInside];
        

        [self.runnerStore.localLife addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.runnerStore.shopping addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.runnerStore.collectView.delegate = self;
        self.runnerStore.collectView.dataSource = self;
        
        //获取数据列表
        [self getDataSourse:@"1"];
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        [LoadIndicator stopAnimationInView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];


    }];
}

#pragma mark - 获取数据源
- (void)getDataSourse:(NSString *)type
{
    [LoadIndicator addIndicatorInView:self.view];

    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:@"1" forKey:@"type"];
    [para setValue:@"0" forKey:@"content"];
    [para setValue:@"1" forKey:@"page"];
    [para setValue:@"1000" forKey:@"rows"];
    [para setValue:[GlobalMethod UserId] forKey:@"id"];
    [NetworkRequest netWorkRequestPOSTWithString:POST_FASTERRUNNER_STORES Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@" ,result);

      
        NSMutableArray *array = [GlobalMethod arrayResults:result];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            RunnerStoreModel *model = [[RunnerStoreModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        [self.collectArray removeAllObjects];
        self.collectArray = dataArray;
        [self.runnerStore.collectView reloadData];
        
        [LoadIndicator stopAnimationInView:self.view];
    } ErrorBlock:^(id error) {
        NSLog(@"%@" , error);
        [LoadIndicator stopAnimationInView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试或检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}







@end
