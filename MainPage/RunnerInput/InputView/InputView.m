//
//  InputView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "InputView.h"
#import "GlobalMethod.h"

@implementation InputView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.voice=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 35)];
//        [self.voice setBackgroundColor:[UIColor grayColor]];
//        [self.voice setTitleColor:FontGray forState:UIControlStateNormal];
        [self.voice setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        [self.voice.layer setCornerRadius:7];
        self.voice.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.voice.layer.borderWidth = 0.5;
        [self addSubview:self.voice];
        
        
        self.textView=[[PlaceholderTextView alloc]initWithFrame:CGRectMake(self.voice.frame.size.width + self.voice.frame.origin.x + 5, 10, frame.size.width - 150, 35)];
        self.textView.placeholder=@"您要什么服务?";
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.font = [UIFont boldSystemFontOfSize:15];
        self.textView.layer.cornerRadius = 7;
        self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.textView.layer.borderWidth = 0.5;
//        [self addSubview:self.textView];
        
        self.sendVoice=[[UIButton alloc]initWithFrame:CGRectMake(self.voice.frame.size.width + self.voice.frame.origin.x + 5, 10, frame.size.width - 150 + 65, 35)];
        [self.sendVoice.layer setCornerRadius:7];
        self.sendVoice.layer.masksToBounds=YES;
        self.sendVoice.layer.borderWidth = 0.5;
        self.sendVoice.backgroundColor = [UIColor whiteColor];
        self.sendVoice.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.sendVoice.titleLabel.font = [UIFont systemFontOfSize:15];
        self.sendVoice.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.sendVoice setTitle:@"按住说话" forState:UIControlStateNormal];
        [self.sendVoice setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.sendVoice];
        
        
        self.sendMessage=[[UIButton alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + self.textView.frame.size.width + 5, 10, 60, 35) ];
        [self.sendMessage setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        [self.sendMessage setTitle:@"发送" forState:UIControlStateNormal];
        self.sendMessage.layer.cornerRadius = 7;
        self.sendMessage.layer.masksToBounds = YES;
        self.sendMessage.titleLabel.font = [UIFont systemFontOfSize:15];
        self.sendMessage.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [self addSubview:self.sendMessage];
        
        self.sendMessage.hidden = YES;
        
        
        self.confirm=[[UIButton alloc]initWithFrame:CGRectMake(20, self.frame.size.height/5+30, self.frame.size.width-40, 50)];
        [self.confirm setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        self.confirm.titleLabel.font = [UIFont systemFontOfSize:17];
        self.confirm.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.confirm setTitle:@"确 定 发 布 订 单" forState:UIControlStateNormal];
        [self.confirm.layer setCornerRadius:7];
    
        self.confirm.layer.masksToBounds=YES;
        [self addSubview:self.confirm];
        
        self.cancle=[[UIButton alloc]initWithFrame:CGRectMake(20, self.confirm.frame.size.height + self.confirm.frame.origin.y + 10, self.frame.size.width-40, 50)];
        [self.cancle.layer setCornerRadius:7];
        self.cancle.titleLabel.font = [UIFont systemFontOfSize:17];
        self.cancle.titleLabel.font =  [UIFont boldSystemFontOfSize:17];
        [self.cancle setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.13]];
        [self.cancle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.cancle setTitle:@"取 消 发 布 订 单" forState:UIControlStateNormal];
        [self addSubview:self.cancle];
        
        
        
        [GlobalMethod drawLineWithFrame:CGRectMake(0, 0, frame.size.width, 0.5) inView:self];
        
    }
    return  self;
}

@end
