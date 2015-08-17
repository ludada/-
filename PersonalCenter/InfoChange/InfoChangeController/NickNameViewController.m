//
//  NickNameViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-4.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "NickNameViewController.h"
#import "GlobalMacro.h"
@interface NickNameViewController ()

@end

@implementation NickNameViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"昵称";
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    right.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=right;
    
    self.nickName=[[UITextField alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT/15)];
    self.nickName.borderStyle=UITextBorderStyleRoundedRect;
    [self.nickName setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.nickName];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)done{
    [self.navigationController popViewControllerAnimated:YES];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:self.nickName.text forKey:@"nickName"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"createNickName" object:nil userInfo:dic];
}

@end
