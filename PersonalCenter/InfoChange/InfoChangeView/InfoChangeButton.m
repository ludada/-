//
//  InfoChangeButton.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-30.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "InfoChangeButton.h"
#import "GlobalMethod.h"
@implementation InfoChangeButton

- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        
        self.label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width/3, self.frame.size.height-20)];
        [self.label1 setTextColor:[UIColor blackColor]];
        self.label1.textAlignment=NSTextAlignmentLeft;
        self.label1.font = [UIFont systemFontOfSize:15];
        self.label1.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.label1];
        
        self.label2=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 10, self.frame.size.width/2, self.frame.size.height-20)];
        self.label2.font = [UIFont systemFontOfSize:15];
        self.label2.font = [UIFont boldSystemFontOfSize:15];
        self.label2.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.label2];
        
        self.lastImg=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 25, (frame.size.height - 17)/2, 10, 17)];
        [self.lastImg setImage:[UIImage imageNamed:@"next1"]];
        [self addSubview:self.lastImg];
        
        [GlobalMethod drawLineWithFrame:CGRectMake(0, 0, frame.size.width, 0.5) inView:self withColor:[UIColor lightGrayColor]];
    }
    
    return self;
}

@end
