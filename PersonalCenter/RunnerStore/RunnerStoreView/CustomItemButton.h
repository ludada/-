//
//  CustomItemButton.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-30.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomItemButton : UIButton

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UILabel *label;


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image label:(NSString *)text;

@end
