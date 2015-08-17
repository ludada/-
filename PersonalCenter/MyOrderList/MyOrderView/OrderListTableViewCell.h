//
//  OrderListTableViewCell.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-5.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  订单列表tableViewcell

#import <UIKit/UIKit.h>
#import "GlobalMacro.h"
@interface OrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderId;

@property (nonatomic, strong) UILabel *orderIdValue;

@property (nonatomic, strong) UILabel *type;

@property (nonatomic, strong) UILabel *name;

@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) UILabel *timeValue;

@property (nonatomic, strong) UILabel *state;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *lineView1;
@end
