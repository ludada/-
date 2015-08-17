//
//  SearchBarView.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-19.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"

@interface SearchBarView : BaseView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) UIButton *search;

@property (nonatomic, strong) UILabel *label;


- (instancetype)initWithFrame:(CGRect)frame label:(NSString *)text;

@end
