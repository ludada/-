//
//  RunnerStoreCollectionViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RunnerStoreCollectionViewCell.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
@implementation RunnerStoreCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
               
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, self.contentView.frame.size.width - 100, self.contentView.frame.size.height - 50)];
        [self.image setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.image];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, self.image.frame.origin.y + self.image.frame.size.height, self.contentView.frame.size.width - 10, 15)];
        [self.title setFont:[UIFont systemFontOfSize:15]];
        [self.title setTextAlignment:NSTextAlignmentLeft];
        [self.title setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.title];
        
        self.coin = [[UILabel alloc] initWithFrame:CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height, 150, 10)];
        [self.coin setFont:[UIFont systemFontOfSize:13]];
        [self.coin setFont:[UIFont boldSystemFontOfSize:13]];
        [self.coin setBackgroundColor:[UIColor clearColor]];
        [self.coin setTextColor:coinColor];
        [self.contentView addSubview:self.coin];
        
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
   
    
    self.image.frame =  CGRectMake(30, 10, self.contentView.frame.size.width - 60, self.contentView.frame.size.height - 70);
//    
//    CGSize size = [GlobalMethod sizeOfText:self.title.text font:15];
    
    CGFloat height = [GlobalMethod GetMyTextHeight:self.title.text font:15 width:self.contentView.frame.size.width - 30];
    
    self.title.frame = CGRectMake(15, self.image.frame.origin.y + self.image.frame.size.height, self.contentView.frame.size.width - 30, height);
    
    self.coin.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height + 5, self.title.frame.size.width, 15);
}
@end
