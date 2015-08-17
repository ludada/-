//
//  InputButton.m
//  FasterRunner
//
//  Created by HLKJ on 15/6/8.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "InputButton.h"

@implementation InputButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.voice=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 10, self.frame.size.height-20, self.frame.size.height-20)];
        [self addSubview:self.voice];
        
        
        
    }
    return self;
}

@end
