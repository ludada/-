//
//  CustomLoginView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "CustomLoginView.h"
#import "GlobalMacro.h"
@implementation CustomLoginView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)myImage placeHold:(NSString *)placeHold
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, frame.size.height)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        backView.layer.cornerRadius = 7;
        backView.layer.masksToBounds = YES;
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        backView.layer.shadowOffset = CGSizeMake(5, 5);
        backView.layer.shadowColor = [[UIColor blackColor] CGColor];
        [self addSubview:backView];
        
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, (frame.size.height - 20)/2, 20, 20)];
        [self.image setImage:myImage];
        [backView addSubview:self.image];
        
        self.field = [[UITextField alloc] initWithFrame:CGRectMake(self.image.frame.origin.x + 10 + self.image.frame.size.width, 0, frame.size.width - 25, frame.size.height)];
        [self.field setPlaceholder:placeHold];
//        [self.field setBackgroundColor:[UIColor orangeColor]];
        [self.field setFont:[UIFont systemFontOfSize:17]];
        [self.field setFont:[UIFont boldSystemFontOfSize:17]];
        [backView addSubview:self.field];
        
    }
    return self;
}

@end
