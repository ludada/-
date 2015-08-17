//
//  OrderListView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "OrderListView.h"

@implementation OrderListView
- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.orderId=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.height/6, self.frame.size.height/3)];
                
        
        
    }
    return self;
}

@end
