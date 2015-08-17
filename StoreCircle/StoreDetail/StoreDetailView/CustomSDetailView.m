//
//  CustomSDetailView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-30.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "CustomSDetailView.h"
@implementation CustomSDetailView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 30, 20)];
        [self.label setText:title];
        [self.label setFont:[UIFont systemFontOfSize:15]];
        [self.label setFont:[UIFont boldSystemFontOfSize:15]];
        [self.label setTextAlignment:NSTextAlignmentLeft];
//        [self.label setBackgroundColor:[UIColor grayColor]];
        [self addSubview:self.label];
        [self.label sizeToFit];
        
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(self.label.frame.size.width + self.label.frame.origin.x + 10, self.label.frame.origin.y, 280, 20)];
//        [self.content setBackgroundColor:[UIColor orangeColor]];
        [self.content setText:content];
        [self.content setFont:[UIFont systemFontOfSize:13]];
        [self.content setFont:[UIFont boldSystemFontOfSize:13]];
        [self.content setTextColor:[UIColor grayColor]];
        [self addSubview:self.content];
        [self.content sizeToFit];
        
        self.image = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 25, 10, 15, 20)];
        [self.image setImage:image forState:UIControlStateNormal];
        [self.image setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self addSubview:self.image];
    }
    return self;
}
@end
