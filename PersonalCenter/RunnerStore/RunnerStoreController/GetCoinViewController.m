//
//  GetCoinViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15/6/12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "GetCoinViewController.h"
#import "GlobalMethod.h"

@interface GetCoinViewController ()<UIWebViewDelegate>

@end

@implementation GetCoinViewController

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
    
    self.navigationItem.title = @"快跑商城";
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
    

    NSURL *url = [NSURL URLWithString:self.getCoinUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    [self.view addSubview:web];
    
    [LoadIndicator addIndicatorInView:self.view];

    
    

    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    [LoadIndicator stopAnimationInView:self.view];
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [LoadIndicator stopAnimationInView:self.view];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [LoadIndicator stopAnimationInView:self.view];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [LoadIndicator stopAnimationInView:self.view];
    
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
