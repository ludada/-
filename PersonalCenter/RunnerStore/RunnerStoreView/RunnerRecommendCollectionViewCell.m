//
//  RunnerRecommendCollectionViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RunnerRecommendCollectionViewCell.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
@implementation RunnerRecommendCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.recommend = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.recommend setImage:[UIImage imageNamed:@"commend"]];
        [self.recommend setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.recommend];
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(self.recommend.frame.origin.x + self.recommend.frame.size.width, 0, self.contentView.frame.size.width - self.recommend.frame.size.width * 2, self.contentView.frame.size.width - self.recommend.frame.size.width * 2)];
        [self.image setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.image];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, self.image.frame.origin.y + self.image.frame.size.height, self.contentView.frame.size.width - 10, 15)];
        [self.title setFont:[UIFont systemFontOfSize:15]];
        [self.title setTextAlignment:NSTextAlignmentLeft];
        [self.title setNumberOfLines:0];
        [self.title setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.title];
        
        self.coin = [[UILabel alloc] initWithFrame:CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height, 150, 10)];
        [self.coin setBackgroundColor:[UIColor clearColor]];
        [self.coin setTextColor:coinColor];
        [self.coin setFont:[UIFont systemFontOfSize:13]];
        [self.coin setFont:[UIFont boldSystemFontOfSize:13]];
        [self.contentView addSubview:self.coin];
        
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.recommend.frame = CGRectMake(0, 0, 40, 40);
    
    CGFloat height = [GlobalMethod GetMyTextHeight:self.title.text font:15 width:self.contentView.frame.size.width - self.recommend.frame.size.width];
     self.title.frame = CGRectMake(self.recommend.frame.size.width, 10, self.contentView.frame.size.width - self.recommend.frame.size.width, height);
    
    self.coin.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height, self.title.frame.size.width, 15);
    
    self.image.frame = CGRectMake(30, self.coin.frame.size.height + self.coin.frame.origin.y + 10, self.contentView.frame.size.width - 60, self.contentView.frame.size.height - self.coin.frame.origin.y - 25);
    
   
    
}
@end
