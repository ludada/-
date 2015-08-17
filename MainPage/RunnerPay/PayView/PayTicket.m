//
//  PayTicket.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PayTicket.h"
#import "UIView+Frame.h"




@implementation PayTicket

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        
        self.isCheck=[[UIButton alloc]initWithFrame:CGRectMake(0,10,self.width/2,20)];
        //[self.isCheck setBackgroundImage:[UIImage imageNamed:@"none"] forState:UIControlStateNormal];
        [self setTitle:@"使用代金券" forState:UIControlStateNormal];
        UIColor *color=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self setBackgroundColor:color];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
//        self.isCheck.layer.borderWidth = 0.2;
//        self.isCheck.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [self addSubview:self.isCheck];
        
        
        
        self.money = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, self.height)];
        [self.money setFont:[UIFont systemFontOfSize:13]];
        [self.money setText:@"代金劵"];
        [self addSubview:self.money];
        
        self.moneyCount = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 40, 0, 80, self.height)];
        [self.moneyCount setTextColor:[UIColor orangeColor]];
        [self.moneyCount setFont:[UIFont systemFontOfSize:13]];
        
        [self addSubview:self.moneyCount];
        
        
        
        
    }
    
    return  self;
}


@end
