//
//  CustomItemButton.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-30.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "CustomItemButton.h"

@implementation CustomItemButton
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image label:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 100)/2, 5, 20, frame.size.height - 10)];
        [self.image setBackgroundColor:[UIColor clearColor]];
        [self.image setImage:image];
        [self addSubview:self.image];
        
        if ([text isEqualToString:@"本地生活"]) {
            self.image.frame = CGRectMake((frame.size.width - 100)/2, 5, 15, frame.size.height - 10);
        }
        else
        {
            self.image.frame = CGRectMake((frame.size.width - 100)/2, 5, 28, frame.size.height - 10);
        }
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.image.frame.size.width + self.image.frame.origin.x + 10, 0, 70, frame.size.height)];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setFont:[UIFont systemFontOfSize:17]];
        [self.label setFont:[UIFont boldSystemFontOfSize:17]];
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setText:text];
        [self addSubview:self.label];
        
    }
    return self;
}
@end
