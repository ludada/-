//
//  AreaViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/8/12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "AreaViewController.h"
#import "GlobalMacro.h"
#import "URLMacro.h"
#import "NetRequestPerfect.h"

@interface AreaViewController ()

@end

@implementation AreaViewController

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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellArea"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    
    [self getAreaData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellArea"];
    
    NSDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"distName"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    
    NSDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    [self.address setValue:[dic objectForKey:@"distName"] forKey:@"areaName"];
    
    [self.address setValue:[dic objectForKey:@"distId"] forKey:@"areaId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDRESS" object:self.address];

    
}

#pragma mark - 获取省份数据

- (void)getAreaData
{
    [NetRequestPerfect NetworkRequestPerfect_POST_WithUrl:POST_AREA param:nil loadingStyle:DYYRequestLoadingStyleIsHubWithErrorAlert inView:self.view success:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        self.tableArray = [dic objectForKey:@"msg"];

        
        [self.tableView reloadData];
        
    } error:^(id error) {
        
        
        
    }];
}






























@end
