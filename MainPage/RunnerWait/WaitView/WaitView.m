//
//  WaitView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "WaitView.h"
#import "GlobalMacro.h"


@implementation WaitView
- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        [self setAlpha:0.8];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.label1=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3-20, 20, self.frame.size.width/3+40,self.frame.size.height/8)];
        self.label1.font=[UIFont systemFontOfSize:12.0];
        [self.label1 setTextColor:[UIColor blackColor]];
        [self addSubview:self.label1];
        
        
        self.label2=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3-20, self.frame.size.height/2, 40, self.frame.size.height/7)];
        [self.label2 setTextColor:[UIColor orangeColor]];
        self.label2.font=[UIFont systemFontOfSize:12.0];
        //[self.label2 setTextColor:[UIColor blackColor]];
        [self addSubview:self.label2];
        
        self.label3=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3+20, self.frame.size.height/2, self.frame.size.width/3, self.frame.size.height/7)];
        self.label3.font=[UIFont systemFontOfSize:12.0];
        [self.label3 setTextColor:[UIColor blackColor]];
        [self addSubview:self.label3];

        
        
        
    }
    return self;
}


@end
