//
//  StoreTableViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-29.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
@implementation StoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, self.contentView.frame.size.height - 6, self.contentView.frame.size.height - 6)];
        [self.image setImage:[UIImage imageNamed:@"shouye1"]];
//        [self.image setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.image];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.image.frame.size.width + self.image.frame.origin.x + 10, 10, 100, 20)];
//        [self.name setBackgroundColor:[UIColor orangeColor]];
        [self.name setTextAlignment:NSTextAlignmentLeft];
//        [self.name setText:@"印巷小馆"];
        [self.name setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.name];
        
        self.style = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frame.origin.x + self.name.frame.size.width + 10, 20, 50, 10)];
//        [self.style setText:@"创意菜"];
//        [self.style setBackgroundColor:[UIColor blueColor]];
        [self.style setFont:[UIFont systemFontOfSize:11]];
        [self.style setTextColor:[UIColor lightGrayColor]];
        [self.style setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.style];
        
        self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height + 10, SCREEN_WIDTH - self.name.frame.origin.x - 50 - 10, 10)];
//        [self.address setText:@"地址: 海淀区 花园里甲2号院四号楼"];
//        [self.address setBackgroundColor:[UIColor yellowColor]];
        [self.address setFont:[UIFont systemFontOfSize:13]];
        [self.address setTextColor:[UIColor lightGrayColor]];
        [self.address setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.address];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(self.address.frame.origin.x, self.address.frame.origin.y + self.address.frame.size.height + 10, self.address.frame.size.width, self.address.frame.size.height)];
        [self.time setFont:[UIFont systemFontOfSize:13]];
        [self.time setTextColor:[UIColor lightGrayColor]];
//        [self.time setText:@"时间: 09:00-22:00"];
//        [self.time setBackgroundColor:[UIColor purpleColor]];
        [self.time setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.time];
        
        [GlobalMethod drawLineWithFrame:CGRectMake(SCREEN_WIDTH - 50, self.address.frame.origin.y - 3, 0.5, 35) inView:self.contentView];
        
        
        self.distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, self.style.frame.origin.y, 50, self.style.frame.size.height)];
//        [self.distance setText:@"2.6km"];
//        [self.distance setBackgroundColor:[UIColor brownColor]];
        [self.distance setFont:[UIFont systemFontOfSize:11]];
        [self.distance setTextColor:[UIColor lightGrayColor]];
        [self.distance setTextAlignment:NSTextAlignmentCenter];
//        [self.contentView addSubview:self.distance];
        
        self.phone = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, self.address.frame.origin.y, 30, 30)];
        [self.phone setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
//        [self.phone setBackgroundColor:[UIColor greenColor]];
        [self.contentView addSubview:self.phone];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(self.time.frame.origin.x, self.contentView.frame.size.height - 0.5, SCREEN_WIDTH - self.name.frame.origin.x, 0.5)];
        [self.line setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.image.frame = CGRectMake(10, 3, self.contentView.frame.size.height - 6, self.contentView.frame.size.height - 6);
    
    self.name.frame = CGRectMake(self.image.frame.size.width + self.image.frame.origin.x + 10, 10, 100, 20);
    [self.name sizeToFit];
    
    self.style.frame = CGRectMake(self.name.frame.origin.x + self.name.frame.size.width + 10, 16, 50, 10);
    
    self.address.frame = CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height + 10, SCREEN_WIDTH - self.name.frame.origin.x - 50 - 10, 10);
    
    self.time.frame = CGRectMake(self.address.frame.origin.x, self.address.frame.origin.y + self.address.frame.size.height + 10, self.address.frame.size.width, self.address.frame.size.height);
    
    self.distance.frame = CGRectMake(SCREEN_WIDTH - 50, self.style.frame.origin.y, 50, self.style.frame.size.height);
    
    self.phone.frame = CGRectMake(SCREEN_WIDTH - 40, self.address.frame.origin.y, 30, 30);
    
    self.line.frame = CGRectMake(self.time.frame.origin.x, self.contentView.frame.size.height - 0.5, SCREEN_WIDTH - self.name.frame.origin.x, 0.5);
    
}

@end
