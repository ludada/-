//
//  RechargeView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RechargeView.h"

@implementation RechargeView

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        //50
        self.backButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/3)];
        [self addSubview:self.backButton1];
        
        self.button1=[[UIButton alloc]initWithFrame:CGRectMake(10, (self.backButton1.frame.size.height - 10)/2, 10, 10)];
        [self.backButton1 addSubview:self.button1];
        
        self.label1=[[UILabel alloc]initWithFrame:CGRectMake(self.button1.frame.size.width + self.button1.frame.origin.x + 10, 0, 80, self.backButton1.frame.size.height)];
        self.label1.text=@"50元";
        [self.backButton1 addSubview:self.label1];
        
    
        //100
        self.backButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, self.backButton1.frame.size.height + self.backButton1.frame.origin.y, frame.size.width, frame.size.height/3)];
        [self addSubview:self.backButton2];
        
        self.button2=[[UIButton alloc]initWithFrame:CGRectMake(10, (self.backButton1.frame.size.height - 10)/2, 10, 10)];
        [self.backButton2 addSubview:self.button2];
        
        self.label2=[[UILabel alloc]initWithFrame:CGRectMake(self.button1.frame.size.width + self.button1.frame.origin.x + 10, 0, 80, self.backButton1.frame.size.height)];
        self.label2.text=@"100元";
        self.label1.textAlignment = NSTextAlignmentLeft;
        self.label2.textAlignment = NSTextAlignmentLeft;
        [self.backButton2 addSubview:self.label2];
        
        
        self.label3=[[UILabel alloc]initWithFrame:CGRectMake(0, self.backButton2.frame.origin.y + self.backButton2.frame.size.height, 80, frame.size.height/3)];
        [self.label3 setTextColor:[UIColor grayColor]];
        self.label3.text=@"自定义";
        [self.label3 setTextAlignment:NSTextAlignmentCenter];
        self.label3.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label3];
        
       
        
        self.money=[[UITextField alloc]initWithFrame:CGRectMake(self.label3.frame.size.width + self.label3.frame.origin.x, self.label3.frame.origin.y + 5, 100, frame.size.height/3 - 10)];
        
        self.money.font = [UIFont systemFontOfSize:15];
        self.money.borderStyle=UITextBorderStyleRoundedRect;
        [self.money setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.money];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return self;
    
}

@end
