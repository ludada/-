//
//  OrderListView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  订单的view

#import "BaseView.h"

@interface OrderListView : BaseView
@property (nonatomic, strong) UILabel *orderId;

@property (nonatomic, strong) UILabel *orderIdValue;

@property (nonatomic, strong) UILabel *type;

@property (nonatomic, strong) UILabel *name;

@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) UILabel *timeValue;

@property (nonatomic, strong) UILabel *state;
@end
