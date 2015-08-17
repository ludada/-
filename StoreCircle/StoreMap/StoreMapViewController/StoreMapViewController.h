//
//  StoreMapViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15/6/4.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKAnnotation.h>



@interface StoreMapViewController : BaseViewController

@property (nonatomic, strong) NSString *adress;

@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *latitude;

@end
