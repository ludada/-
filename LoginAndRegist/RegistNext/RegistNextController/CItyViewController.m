//
//  CItyViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/8/12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "CItyViewController.h"
#import "GlobalMacro.h"
#import "URLMacro.h"
#import "NetRequestPerfect.h"
#import "AreaViewController.h"

@interface CItyViewController ()

@end

@implementation CItyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.backButton = YES;
        
        
        self.tableArray = [NSMutableArray array];
        
        
        self.address = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellCity"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self getCityData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellCity"];
    
    NSDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"cityName"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     AreaViewController *area = [[AreaViewController alloc] init];
    
    [self.navigationController pushViewController:area animated:YES];

    NSDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    [area.address setValue:[dic objectForKey:@"cityName"] forKey:@"cityName"];
    
    [area.address setValue:[dic objectForKey:@"cityId"] forKey:@"cityId"];
    
    [area.address setValue:[self.address objectForKey:@"provinceId"] forKey:@"provinceId"];
    
    [area.address setValue:[self.address objectForKey:@"provinceName"] forKey:@"provinceName"];
    
    
}



#pragma mark - 获取省份数据

- (void)getCityData
{
    [NetRequestPerfect NetworkRequestPerfect_POST_WithUrl:POST_CITY param:nil loadingStyle:DYYRequestLoadingStyleIsHubWithErrorAlert inView:self.view success:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        self.tableArray = [dic objectForKey:@"msg"];

        
        [self.tableView reloadData];
        
    } error:^(id error) {
        
        
        
    }];
}

























@end
