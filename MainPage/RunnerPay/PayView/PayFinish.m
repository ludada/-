//
//  PayFinish.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PayFinish.h"
#import "UIView+Frame.h"
@implementation PayFinish

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        
        self.pay=[[UIButton alloc]initWithFrame:CGRectMake(15, 10, (frame.size.width - 40)/2, 35)];
        [self.pay setBackgroundImage:[UIImage imageNamed:@"paybtn"] forState:UIControlStateNormal];
        [self addSubview:self.pay];
        
        UILabel *labelPay = [[UILabel alloc] initWithFrame:CGRectMake(self.pay.frame.size.width/3*2 - 10, 0, 30, self.pay.frame.size.height)];
        [labelPay setText:@"支付"];
        [labelPay setFont:[UIFont systemFontOfSize:15]];
        [labelPay setTextColor:[UIColor whiteColor]];
        [labelPay setTextAlignment:NSTextAlignmentCenter];
        [self.pay addSubview:labelPay];
        
        
        
        self.finish=[[UIButton alloc]initWithFrame:CGRectMake(self.pay.frame.size.width + self.pay.frame.origin.x + 10, self.pay.frame.origin.y, (frame.size.width - 40)/2, 35)];
        [self.finish setBackgroundImage:[UIImage imageNamed:@"okbtn"] forState:UIControlStateNormal];
        [self addSubview:self.finish];

        
        UILabel *labelFinish = [[UILabel alloc] initWithFrame:CGRectMake(self.finish.frame.size.width/3*2 - 10, 0, 30, self.finish.frame.size.height)];
        [labelFinish setText:@"完成"];
        [labelFinish setFont:[UIFont systemFontOfSize:15]];
        [labelFinish setTextColor:[UIColor whiteColor]];
        [labelFinish setTextAlignment:NSTextAlignmentCenter];
        [self.finish addSubview:labelFinish];

        
        
        
    }
    return  self;
}


@end
