//
//  ChangeView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "ChangeView.h"

@implementation ChangeView

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.headImg=[[UIButton alloc]initWithFrame:CGRectMake((frame.size.width - 60)/2, 20, 60, 60)];
        self.headImg.layer.masksToBounds = YES;
        self.headImg.layer.cornerRadius = 4;
        [self addSubview:self.headImg];    }
    
    
    return self;
}

@end
