//
//  PersonalHeadView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-29.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PersonalHeadView.h"

@implementation PersonalHeadView

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.headView=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.height-20, self.frame.size.height-20)];
        [self addSubview:self.headView];
        
        self.name=[[UILabel alloc]initWithFrame:CGRectMake(self.headView.frame.size.width + self.headView.frame.origin.x + 10, 15, self.frame.size.width/3, 15)];
        self.name.font=[UIFont systemFontOfSize:15];
        self.name.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.name];
        
        
        self.phone=[[UILabel alloc]initWithFrame:CGRectMake(self.name.frame.origin.x , self.name.frame.origin.y + self.name.frame.size.height + 10, 200, 15)];
        self.phone.font=[UIFont systemFontOfSize:15.0];
        [self.phone setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.phone];
    }
    return  self;
    
}
@end
