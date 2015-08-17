//
//  ProvinceViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/8/12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "ProvinceViewController.h"
#import "GlobalMacro.h"
#import "CItyViewController.h"
#import "NetRequestPerfect.h"
#import "URLMacro.h"

@interface ProvinceViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ProvinceViewController

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
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellProvince"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self getProvinceData];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellProvince"];
    
    NSDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"provName"];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CItyViewController  *city = [[CItyViewController alloc] init];
    
    [self.navigationController pushViewController:city animated:YES];
    
    
    NSDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];

    [city.address setValue:[dic objectForKey:@"provName"] forKey:@"provinceName"];
    
    [city.address setValue:[dic objectForKey:@"provId"] forKey:@"provinceId"];
    
    
}


#pragma mark - 获取省份数据

- (void)getProvinceData
{
    [NetRequestPerfect NetworkRequestPerfect_POST_WithUrl:POST_PROVINCE param:nil loadingStyle:DYYRequestLoadingStyleIsHubWithErrorAlert inView:self.view success:^(id result) {
        
        NSDictionary *dic = (NSDictionary *)result;
        
        self.tableArray = [dic objectForKey:@"msg"];
        
        [self.tableView reloadData];
        
    } error:^(id error) {
        
        
        
    }];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
