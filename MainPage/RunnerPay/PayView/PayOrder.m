//
//  PayOrder.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PayOrder.h"
#import "UIView+Frame.h"



@implementation PayOrder

- (id)initWithFrame:(CGRect)frame cost:(NSString *)myCost award:(NSString *)myAward
{
    
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.alpha=0.8;
        
        //花费
        self.cost = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 15)];
        [self.cost setFont:[UIFont systemFontOfSize:15]];
        [self.cost setFont:[UIFont boldSystemFontOfSize:15]];
        [self.cost setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.cost];
        
        //奖励
        self.award = [[UILabel alloc] initWithFrame:CGRectMake(0, self.cost.frame.size.height + self.cost.frame.origin.y + 10, frame.size.width, 15)];
        [self.award setFont:[UIFont systemFontOfSize:15]];
        [self.award setFont:[UIFont boldSystemFontOfSize:15]];
        [self.award setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.award];
        
        
        //前往积分商城
        self.toStore = [[UILabel alloc] initWithFrame:CGRectMake(0, self.award.frame.size.height + self.award.frame.origin.y + 10, frame.size.width, 15)];
        [self.toStore setFont:[UIFont systemFontOfSize:15]];
        [self.toStore setFont:[UIFont boldSystemFontOfSize:15]];
        [self.toStore setTextAlignment:NSTextAlignmentCenter];
        [self.toStore setText:@"点击前往积分商城兑换好礼"];
        [self addSubview:self.toStore];

        
        
//        
//        //完成订单
//        self.label1=[[UILabel alloc]initWithFrame:CGRectMake(self.width/4,5, 85, 15)];
//        [self.label1 setTextColor:[UIColor blackColor]];
//        self.label1.font=[UIFont systemFontOfSize:13.0];
//        [self addSubview:self.label1];
//        
//        //20 金币
//        self.label=[[UILabel alloc]initWithFrame:CGRectMake(self.label1.frame.size.width + self.label1.frame.origin.x + 3, self.label1.frame.origin.y, 40, 15)];
//        [self.label setTextColor:[UIColor orangeColor]];
//        self.label.font=[UIFont systemFontOfSize:13];
//        [self addSubview:self.label];
//        
//        //前往
//        self.label2=[[UILabel alloc]initWithFrame:CGRectMake(0, self.label1.frame.size.height + self.label1.frame.origin.y + 10, self.width, 15)];
//        [self.label2 setTextColor:[UIColor blackColor]];
//        [self.label2 setTextAlignment:NSTextAlignmentCenter];
//        self.label2.font=[UIFont systemFontOfSize:13.0];
//        [self addSubview:self.label2];
//        
        
    }
    return self;
}



@end
