//
//  SearchBarView.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-19.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

- (instancetype)initWithFrame:(CGRect)frame label:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];

        //背景视图
        self.view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, frame.size.width - 10, frame.size.height)];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        //搜索输入框
        self.field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.field.font = [UIFont systemFontOfSize:13];
        self.field.delegate = self;
        [self.view addSubview:self.field];
        
        //搜索按钮(放大镜)
        self.search = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width - 90)/2, 2, 25, 25)];
        [self.search setImage:[UIImage imageNamed:@"searchbutton"] forState:UIControlStateNormal];
        [self.view addSubview:self.search];
        
        //放大镜旁边的字
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.search.frame.size.width + self.search.frame.origin.x, 0, 75, frame.size.height)];
        [self.label setFont:[UIFont systemFontOfSize:13]];
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setText:text];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:self.label];
        
    }
    return self;
}



//点击输入框的时候 第一步会走这个方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.05 animations:^{
        self.field.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self.label setFrame:CGRectMake(0, 0, 0, 0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.search.frame = CGRectMake(self.view.frame.size.width - 25, 2, 25, 25);
        } completion:nil];
    }];
    return YES;
}









@end
