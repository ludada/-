//
//  LoadIndicator.m
//  ChatDemo-UI2.0
//
//  Created by HLKJ on 15-4-24.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "LoadIndicator.h"

@implementation LoadIndicator
/*数据加载风火轮*/
+ (void)addIndicatorInView:(UIView *)inView
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(inView.center.x, inView.center.y - 64);
    indicator.tag = 999;
    [inView addSubview:indicator];
    [indicator startAnimating];
    
    
}

/*停止风火轮*/
+ (void)stopAnimationInView:(UIView *)inView
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[inView viewWithTag:999];
    [indicator removeFromSuperview];
    [indicator stopAnimating];
    indicator = nil;
}
@end
