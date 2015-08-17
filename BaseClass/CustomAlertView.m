//
//  CustomAlertView.m
//  Test
//
//  Created by HLKJ on 15/6/11.
//  Copyright (c) 2015年 com.hlkj. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)CreateMyCustomAlert
{
    
    self.backGround = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.backGround setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.15]];
    [self addSubview:self.backGround];
    
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 40, 192)];
    myView.center = CGPointMake(self.backGround.center.x, self.backGround.center.y - 32);
    [myView setBackgroundColor:[UIColor whiteColor]];
    myView.layer.cornerRadius = 5;
    myView.layer.masksToBounds = YES;
    [self.backGround addSubview:myView];
    
    
    
    
    //设置背景
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
//    self.layer.shadowOpacity = 0.5;
//    self.layer.shadowColor = [[UIColor grayColor] CGColor];
//    self.layer.shadowOffset = CGSizeMake(10, 10);
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    
    
    
    //没人抢，继续叫
    self.continueRush = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, myView.frame.size.width - 30, 44)];
    [self.continueRush setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    self.continueRush.layer.cornerRadius = 5;
    self.continueRush.layer.masksToBounds = YES;
    [self.continueRush setTitle:@"没人抢, 继续叫" forState:UIControlStateNormal];
    [self.continueRush setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueRush.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [self.continueRush.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [myView addSubview:self.continueRush];
    
    
    self.run = [[UIImageView alloc] initWithFrame:CGRectMake(40, 8, 25, 25)];
    [self.run setImage:[UIImage imageNamed:@"run"]];
    [self.continueRush addSubview:self.run];
    
    
    
    
    //不差钱，打电话
    self.contactServer = [[UIButton alloc] initWithFrame:CGRectMake(self.continueRush.frame.origin.x, self.continueRush.frame.origin.y + self.continueRush.frame.size.height + 10, self.continueRush.frame.size.width, self.continueRush.frame.size.height)];
    [self.contactServer setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    self.contactServer.layer.cornerRadius = 5;
    self.contactServer.layer.masksToBounds = YES;
    [self.contactServer setTitle:@"联系快跑吧" forState:UIControlStateNormal];
    [self.contactServer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contactServer.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [self.contactServer.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [myView addSubview:self.contactServer];
    
    self.phone = [[UIImageView alloc] initWithFrame:CGRectMake(40, 8, 25, 25)];
    [self.phone setImage:[UIImage imageNamed:@"tel_white"]];
    [self.contactServer addSubview:self.phone];
    


    
    
    //取消订单
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.continueRush.frame.origin.x, self.contactServer.frame.size.height + self.contactServer.frame.origin.y + 10, self.contactServer.frame.size.width, self.continueRush.frame.size.height)];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;

    [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [myView addSubview:self.cancelButton];

    
}


@end
