//
//  NetRequestPerfect.m
//  NetWorkingRequest
//
//  Created by HLKJ on 15/7/21.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "NetRequestPerfect.h"

#import "AFNetworking.h"

#import "NetworkRequest.h"

#import "MBProgressHUD.h"
                                                                                                                   
@implementation NetRequestPerfect


#pragma mark - post请求

+ (void)NetworkRequestPerfect_POST_WithUrl:(NSString *)url
                                     param:(NSDictionary *)param
                              loadingStyle:(DYYRequestLoadingStyle)style
                                    inView:(UIView *)view
                             success:(ResponseBlock)successBlocks
                               error:(ErrorBlock)errorBlocks
{
    //拼接网址
    NSString *globalUrl = @"";
    
    for (NSString *key in param.allKeys) {
        
        if ([globalUrl isEqualToString:@""]) {
            
            globalUrl = [NSString stringWithFormat:@"%@=%@", key, [param objectForKey:key]];
            
        }
        else
        {
            globalUrl = [NSString stringWithFormat:@"%@&%@=%@", param, key, [param objectForKey:key]];
        }
        
    }
    //打印网址

    NSString *myUrl = [NSString stringWithFormat:@"%@%@", url, globalUrl];
    
    NSLog(@"POST_URL : %@", myUrl);
    
    //打印参数
    NSLog(@"PARAMS   : %@", param);
    
    
    //添加加载动画
    MBProgressHUD *hud = nil;
    
    //添加菊花
    UIActivityIndicatorView *indicator = nil;
    
    if (style == DYYRequestLoadingStyleIsHub || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
        
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = @"载入中..";
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType = MBProgressHUDAnimationFade;

    }
    else if (style == DYYRequestLoadingStyleIsIndicator || style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert)
    {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(view.center.x, view.center.y);
        [view addSubview:indicator];
        [indicator startAnimating];
    }
    else
    {
        NSLog(@"没有加载");
    }
    
    //进行网络请求
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:param ResponseBlock:^(id result) {
        
        NSLog(@"返回数据 : %@", result);
        
        successBlocks(result);
        
        //隐藏加载
        if (style == DYYRequestLoadingStyleIsHub || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
            
            [hud hide:YES afterDelay:1.5];
            
        }
        else if (style == DYYRequestLoadingStyleIsIndicator || style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert)
        {
            [indicator stopAnimating];
            [indicator hidesWhenStopped];
            [indicator removeFromSuperview];

        }
        else
        {
            
        }
        
    } ErrorBlock:^(id error) {
        
        NSLog(@"返回错误 : %@", error);
        
        //隐藏加载
        if (style == DYYRequestLoadingStyleIsHub || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
            
            [hud hide:YES afterDelay:1.5];
            
        }
        else if (style == DYYRequestLoadingStyleIsIndicator || style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert)
        {
            [indicator stopAnimating];
            [indicator hidesWhenStopped];
            [indicator removeFromSuperview];
            
        }
        else
        {
            
        }
        
        //回调block
        errorBlocks(error);
        
        
        if (style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
            
            //添加错误提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络无法连接" message:@"请重试或检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            

        }
        
        
    }];
}


#pragma mark - get请求
+ (void)NetworkRequestPerfect_GET_WithUrl:(NSString *)url
                              loadingStyle:(DYYRequestLoadingStyle)style
                                    inView:(UIView *)view
                                   success:(ResponseBlock)successBlocks
                                     error:(ErrorBlock)errorBlocks
{
    
    NSLog(@"GET_URL : %@", url);

    
    //添加加载动画
    MBProgressHUD *hud = nil;
    
    //添加菊花
    UIActivityIndicatorView *indicator = nil;
    
    if (style == DYYRequestLoadingStyleIsHub || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
        
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = @"载入中..";
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType = MBProgressHUDAnimationFade;
        
    }
    else if (style == DYYRequestLoadingStyleIsIndicator || style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert)
    {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(view.center.x, view.center.y);
        [view addSubview:indicator];
        [indicator startAnimating];
    }
    else
    {
        //什么也不操作
    }
    
    //进行网络请求
    [NetworkRequest netWorkRequestGetWithString:url ResponseBlock:^(id result) {
        
        NSLog(@"返回数据 : %@", result);
        
        successBlocks(result);
        
        //隐藏加载
        if (style == DYYRequestLoadingStyleIsHub || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
            
            [hud hide:YES afterDelay:1.5];
            
        }
        else if (style == DYYRequestLoadingStyleIsIndicator || style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert)
        {
            [indicator stopAnimating];
            [indicator hidesWhenStopped];
            [indicator removeFromSuperview];
            
        }
        else
        {
            
        }
        
    } ErrorBlock:^(id error) {
        
        NSLog(@"返回错误 : %@", error);
        
        //隐藏加载
        if (style == DYYRequestLoadingStyleIsHub || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
            
            [hud hide:YES afterDelay:1.5];
            
        }
        else if (style == DYYRequestLoadingStyleIsIndicator || style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert)
        {
            [indicator stopAnimating];
            [indicator hidesWhenStopped];
            [indicator removeFromSuperview];
            
        }
        else
        {
            
        }
        
        //回调block
        errorBlocks(error);
        
        if (style == DYYRequestLoadingStyleIsIndicatorWithErrorAlert || style == DYYRequestLoadingStyleIsHubWithErrorAlert) {
            
            //添加错误提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络无法连接" message:@"请重试或检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
        
        
    }];
}




@end
