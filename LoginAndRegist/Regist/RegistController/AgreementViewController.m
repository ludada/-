//
//  AgreementViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/6/17.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "AgreementViewController.h"
#import "LoadIndicator.h"
#import "NetworkRequest.h"
#import "GlobalMethod.h"
@interface AgreementViewController ()<UIWebViewDelegate>

//123.57.222.175:3306

@end

@implementation AgreementViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务条款";
    
    [NetworkRequest netWorkRequestPOSTWithString:@"http://123.57.222.175:8080/runfast/UsersAction!usersTermService.action" Parameters:nil ResponseBlock:^(id result) {
        NSDictionary *dic = [GlobalMethod dictionaryResults:result];
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"path"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        web.delegate = self;
        [web loadRequest:request];
        [self.view addSubview:web];

        [LoadIndicator addIndicatorInView:self.view];
        
        
    } ErrorBlock:^(id error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接出现错误" message:@"请重试会检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }];
    
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [LoadIndicator stopAnimationInView:self.view];
    return YES;
}

- (void)dismissAlert:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
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
