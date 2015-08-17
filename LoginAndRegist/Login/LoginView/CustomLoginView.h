//
//  CustomLoginView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"

@interface CustomLoginView : BaseView

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UITextField *field;


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)myImage placeHold:(NSString *)placeHold;

@end
