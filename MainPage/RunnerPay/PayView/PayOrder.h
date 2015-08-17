//
//  PayOrder.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrder : UIButton

@property (nonatomic, strong) UILabel *cost;

@property (nonatomic, strong) UILabel *award;

@property (nonatomic, strong) UILabel *toStore;


- (id)initWithFrame:(CGRect)frame cost:(NSString *)myCost award:(NSString *)myAward;

@end
