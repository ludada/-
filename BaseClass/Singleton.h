//
//  Singleton.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKLocationService.h>



@interface Singleton : NSObject

@property (nonatomic, strong) NSMutableArray *myTabArray;

@property (nonatomic, strong) NSDictionary *orderList;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) BOOL redBall;

+ (id)shareInstance;

@end
