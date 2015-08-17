//
//  PersonalView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "PersonalView.h"
#import "GlobalMethod.h"
@implementation PersonalView
- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.button setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.button];
        
        self.headImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.button.frame.size.height/3, self.button.frame.size.height/3, self.button.frame.size.height/3, self.button.frame.size.height/3)];
        
        [self.button addSubview:self.headImg];
        
        
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(self.button.frame.size.height, self.button.frame.size.height/3, self.button.frame.size.width/3, self.button.frame.size.height/3)];
        [self.label setFont:[UIFont systemFontOfSize:14]];
        [self.button addSubview:self.label];
        
        
        self.lastImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 20, self.button.frame.size.height/3, self.button.frame.size.height/6, self.button.frame.size.height/3)];
        [self.lastImg setImage:[UIImage imageNamed:@"next"]];
        [self.button addSubview:self.lastImg];
        
        
        
        [GlobalMethod drawLineWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5) inView:self];
        
        
        
    }
    return  self;
}
@end
