//
//  StoreDetailViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreDetailView.h"
#import "GlobalMacro.h"
#import "NetworkRequest.h"
#import "URLMacro.h"
#import "StoreMapViewController.h"
#import "GlobalMethod.h"
#import "StoreDetailModel.h"
#import "CustomSDetailView.h"
#import "SJAvatarBrowser.h"

@interface StoreDetailViewController ()

@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *latitude;

@end

@implementation StoreDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    self.detail = [[StoreDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.detail createDetailView];
    self.view = self.detail;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getstoreDetailData];
    
    [LoadIndicator addIndicatorInView:self.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.hideTab = YES;

}


#pragma mark - 获取商圈详情数据
- (void)getstoreDetailData
{
    NSDictionary *para = @{@"id" : self.storeDetailId};
    
    [NetworkRequest netWorkRequestPOSTWithString:POST_STORE_DETAIL Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        StoreDetailModel *model = [[StoreDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        self.detail.dataModel = model;
        
        //上图  添加点击事件
        for (int i = 0; i < self.detail.upPicArray.count; i++) {
            UIButton *button = (UIButton *)[self.detail.scrollUp viewWithTag:100 + i];
//            [button addTarget:slf action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>]
        }
        
        for (int j = 0; j < self.detail.downPicArray.count; j ++) {
            UIButton *button = (UIButton *)[self.detail.scrollDown viewWithTag:1000 + j];
            //添加点击事件
            
        }
        
        
        [self.detail.address.image addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.detail.tele.image addTarget:self action:@selector(teleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.detail.tele.image addTarget:self action:@selector(teleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.detail.tele.image setTitle:self.detail.tele.content.text forState:UIControlStateNormal];

        [self.detail.tele setTitle:self.detail.tele.content.text forState:UIControlStateNormal];
        
        [self.detail.tele setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [self.detail.tele.image setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        
        self.navigationItem.title = model.circName;
        [LoadIndicator stopAnimationInView:self.view];
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        [LoadIndicator stopAnimationInView:self.view];
    }];
}



#pragma mark - 地图定位
- (void)addressAction:(id)sender
{
    //跳转地图定位界面   定位后  再返回
    StoreMapViewController *map=[[StoreMapViewController alloc]init];
    map.adress=self.detail.address.content.text;
    map.latitude=self.detail.dataModel.latitude;
    map.longitude=self.detail.dataModel.longitude;
    [self.navigationController pushViewController:map animated:YES];
}

#pragma mark - 电话拨打
- (void)teleAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", button.currentTitle];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}









@end
