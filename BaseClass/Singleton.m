//
//  Singleton.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "Singleton.h"

static Singleton *share = nil;
@implementation Singleton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myTabArray = [NSMutableArray array];
        self.orderList = [NSDictionary dictionary];

        self.redBall = NO;
    }
    return self;
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        share = [[Singleton alloc] init];
    });
    return share;
}

@end
