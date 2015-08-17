//
//  LoadIndicator.h
//  ChatDemo-UI2.0
//
//  Created by HLKJ on 15-4-24.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LoadIndicator : NSObject

/*数据加载风火轮*/
+ (void)addIndicatorInView:(UIView *)inView;
/*停止风火轮*/
+ (void)stopAnimationInView:(UIView *)inView;

@end
