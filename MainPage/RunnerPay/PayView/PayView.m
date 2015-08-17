//
//  PayView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PayView.h"
#import "UIView+Frame.h"


@implementation PayView

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.headImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,self.height-20 ,self.height-20)];
        [self.headImg.layer setCornerRadius:self.height/2-10];
        self.headImg.layer.masksToBounds=YES;
        [self addSubview:self.headImg];
        
        self.name=[[UILabel alloc]initWithFrame:CGRectMake(self.headImg.x+self.headImg.width+10, 10, self.width/3, self.height/2-10)];
        [self.name setTextColor:[UIColor blackColor]];
        self.name.textAlignment=UITextAlignmentLeft;
        self.name.font=[UIFont systemFontOfSize:15];
        [self addSubview:self.name];
        
        self.carId=[[UILabel alloc]initWithFrame:CGRectMake(self.name.x, self.height/2, self.width/3, self.height/2-10)];
        [self.carId setTextColor:[UIColor grayColor]];
        self.carId.font=[UIFont systemFontOfSize:12.0];
        self.carId.textAlignment=UITextAlignmentLeft;
        [self addSubview:self.carId];
        
        [GlobalMethod drawLineWithFrame:CGRectMake(self.width*4/5, 10, 1.5, self.height-20) inView:self];
        
        
        self.backPhone = [[UIButton alloc] initWithFrame:CGRectMake(self.width*4/5, 0, self.width/5, self.height)];
        [self addSubview:self.backPhone];
        
        self.phone=[[UIButton alloc]initWithFrame:CGRectMake( (self.width/5 - 25)/2 , 22.5, 25, 25)];
        [self.phone setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        
        [self.backPhone addSubview:self.phone];
        
        
        
    }
    return  self;
    
}

@end
