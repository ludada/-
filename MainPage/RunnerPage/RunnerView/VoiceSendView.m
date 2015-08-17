//
//  VoiceSendView.m
//  FasterRunner
//
//  Created by HLKJ on 15/6/2.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "VoiceSendView.h"

@implementation VoiceSendView

- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        self.alpha=0.7;
        
        self.duijiangji=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/4, 10, self.frame.size.width/4-10, self.frame.size.height*3/4)];
        [self.duijiangji setImage:[UIImage imageNamed:@"duijiangji"]];
        [self addSubview:self.duijiangji];
        
        self.volume=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 10, self.frame.size.width/4-10, self.frame.size.height*3/4)];
        [self addSubview:self.volume];
        
        
    }
    return self;
}
@end
