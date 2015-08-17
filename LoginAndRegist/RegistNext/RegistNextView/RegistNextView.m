//
//  RegistNextView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RegistNextView.h"
#import "CustomLoginView.h"
#import "GlobalMacro.h"
@implementation RegistNextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createRegistNextView
{
    self.headImg = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, 30, 120, 120)];
    [self.headImg setBackgroundColor:[UIColor orangeColor]];
    [self.headImg setImage:[UIImage imageNamed:@"headimage"] forState:UIControlStateNormal];
    self.headImg.layer.cornerRadius = 7;
    self.headImg.layer.masksToBounds = YES;
    [self addSubview:self.headImg];
    
    NSArray *array = [NSArray arrayWithObjects:@"男", @"女",nil];
    self.segControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segControl.frame = CGRectMake(self.headImg.frame.origin.x, self.headImg.frame.origin.y +self.headImg.frame.size.height + 30, self.headImg.frame.size.width, 35);
    [self.segControl setSelectedSegmentIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.f], NSFontAttributeName,nil];
    [self.segControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self.segControl setTintColor:Blue];
    [self addSubview:self.segControl];
    
    self.nickName = [[CustomLoginView alloc] initWithFrame:CGRectMake(0, self.segControl.frame.origin.y + self.segControl.frame.size.height + 15, SCREEN_WIDTH, 50) image:[UIImage imageNamed:@"wode"] placeHold:@"昵称"];
    [self addSubview:self.nickName];
    
    self.address = [[CustomLoginView alloc] initWithFrame:CGRectMake(0, self.nickName.frame.size.height + self.nickName.frame.origin.y + 10, SCREEN_WIDTH, self.nickName.frame.size.height) image:[UIImage imageNamed:@"email"] placeHold:@"常用地址"];
//    self.address.field.tag = 111;
    self.address.field.userInteractionEnabled = NO;
    
    self.regionButton = [[UIButton alloc] initWithFrame:CGRectMake(40, self.address.frame.origin.y, SCREEN_WIDTH - 90, self.address.frame.size.height)];
    [self.regionButton setBackgroundColor:[UIColor clearColor]];
    [self.regionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.regionButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.regionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    
    [self addSubview:self.address];
    
    
    self.go = [[UIButton alloc] initWithFrame:CGRectMake(20, self.address.frame.size.height + self.address.frame.origin.y + 20, SCREEN_WIDTH - 40, 50)];
    [self.go setTitle:@"进入快跑" forState:UIControlStateNormal];
    [self.go setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.go setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    self.go.layer.cornerRadius = 7;
    self.go.layer.masksToBounds = YES;
    [self addSubview:self.go];
    
    
    [self addSubview:self.regionButton];

}


@end