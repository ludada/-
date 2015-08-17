//
//  CustomSDetailView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-30.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSDetailView : UIButton

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *content;

@property (nonatomic, strong) UIButton *image;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content image:(UIImage *)image;

@end
