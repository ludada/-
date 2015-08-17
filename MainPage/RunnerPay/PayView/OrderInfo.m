//
//  OrderInfo.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "OrderInfo.h"
#import "UIView+Frame.h"
#import "GlobalMacro.h"

#import "GlobalMethod.h"


@implementation OrderInfo
- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        
     UIColor *color1=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.layer setCornerRadius:10.0];
        self.layer.masksToBounds=YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/4)];
        [self.headView setBackgroundColor:color1];
        [self addSubview:self.headView];
        
        self.orderId=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 50, self.height/4)];
        self.orderId.font=[UIFont systemFontOfSize:15];
        [self.orderId setTextColor:[UIColor blackColor]];
        self.orderId.text=@"订单号";
        [self addSubview:self.orderId];
        
        self.orderIdValue=[[UILabel alloc]initWithFrame:CGRectMake(self.orderId.width+self.orderId.x + 10, self.orderId.y, SCREEN_WIDTH/2 + 20, self.orderId.height)];
        [self.orderIdValue setTextColor:[GlobalMethod hexStringToColor:@"#32cd32"]];
        self.orderIdValue.font=[UIFont systemFontOfSize:15];
//        self.orderIdValue.text=@"dfaldjfpaijfpda";
        [self addSubview:self.orderIdValue];
        
        
        self.contacts = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headView.x + self.headView.height , frame.size.width, self.headView.frame.size.height)];
        [self.contacts setFont:[UIFont systemFontOfSize:13]];
        [self.contacts setFont:[UIFont boldSystemFontOfSize:13]];
        [self.contacts setTextColor:[UIColor blackColor]];
        [self.contacts setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.contacts];
        
               
        [GlobalMethod drawLineWithFrame:CGRectMake(20, self.height*2/4+4, self.width-40, 1) inView:self withColor:[UIColor grayColor]];
        
        
        self.addTime=[[UILabel alloc]initWithFrame:CGRectMake(20, self.height/4 *2, (self.width - 40)/2, self.height/4)];
//        self.addTime.text=@"aldjflajlfajlfajl";
        [self.addTime setTextColor:[UIColor grayColor]];
        self.addTime.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.addTime];
        
        
        self.money=[[UILabel alloc]initWithFrame:CGRectMake((self.width - 40)/2 + 15, self.height/4 *3, (self.width - 40)/2, self.height/4)];
        self.money.font=[UIFont systemFontOfSize:15];
//        self.money.text=@"金额:  5";
        [self.money setTextAlignment:NSTextAlignmentRight];
        [self.money setTextColor:[UIColor blackColor]];
        [self addSubview:self.money];
        
        self.money.attributedText = [GlobalMethod fuwenbenLabel:@"需支付:  5元" FontNumber:[UIFont systemFontOfSize:13] AndRange:NSMakeRange(6, 2) AndColor:[UIColor redColor]];
        
        
        
    
       //代金卷
        self.insteadCash = [[UILabel alloc] initWithFrame:CGRectMake(20, self.height/4 * 3, (self.width)/2, self.height/4)];
        [self.insteadCash setTextColor:[GlobalMethod hexStringToColor:@"#32cd32"]];
        [self.insteadCash setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.insteadCash];
        
        
        
        
        
    }
    return self;
}

@end
