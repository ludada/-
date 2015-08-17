//
//  StoreSearchViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-6.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreSearchViewController.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
#import "NetworkRequest.h"
#import "RunnerStoreCollectionViewCell.h"
#import "URLMacro.h"
#import "StoreSearchModel.h"
#import "UIImageView+WebCache.h"
#import "GoodsDetailViewController.h"
@interface StoreSearchViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation StoreSearchViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
        self.collectArray = [NSMutableArray array];
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    self.storeSearch = [[StoreSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.storeSearch createSearchView];
    self.view = self.storeSearch;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"快跑商城";
    self.storeSearch.collectView.delegate = self;
    self.storeSearch.collectView.dataSource = self;
    
    [self.storeSearch.search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.storeSearch.searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.storeSearch.content addTarget:self action:@selector(textDidChangeS:) forControlEvents:UIControlEventEditingChanged];
    
    [self searchDataFromServer];
}

#pragma mark -  监控输入框的改变
- (void)textDidChangeS:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    if ([textField.text isEqualToString:@""]) {
        //为空时调用网络请求 获取全部数据
        [self searchDataFromServer];
    }

}



#pragma mark - tableview点击事件

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
    
    StoreSearchModel *model = [self.collectArray objectAtIndex:indexPath.row];
    RunnerStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    [cell.image setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
    [cell.title setText:model.title];
    [cell.coin setText:model.pointsCount];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    StoreSearchModel *model = [self.collectArray objectAtIndex:indexPath.row];
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    [self.navigationController pushViewController:goods animated:YES];
    goods.goodsId = model.id;
}



//搜索点击事件
- (void)searchAction:(id)sender
{
    [self.view endEditing:YES];
    [self searchDataFromServer];
}

/**
 *  获取搜索数据
 */
- (void)searchDataFromServer
{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:@"3" forKey:@"type"];
    [para setValue:self.storeSearch.content.text forKey:@"content"];
    [para setValue:@"1" forKey:@"page"];
    [para setValue:@"1000" forKey:@"rows"];
    [para setValue:[GlobalMethod UserId] forKey:@"id"];
    [NetworkRequest netWorkRequestPOSTWithString:POST_FASTERRUNNER_STORES Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@" ,result);
        
        
        NSMutableArray *array = [GlobalMethod arrayResults:result];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            StoreSearchModel *model = [[StoreSearchModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        [self.collectArray removeAllObjects];
        self.collectArray = dataArray;
        [self.storeSearch.collectView reloadData];
        
        [LoadIndicator stopAnimationInView:self.view];
    } ErrorBlock:^(id error) {
        NSLog(@"%@" , error);
        [LoadIndicator stopAnimationInView:self.view];
        
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideTab = YES;
}

@end