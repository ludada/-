//
//  WaitView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  等待应答界面的View

#import "BaseView.h"
#import <BaiduMapAPI/BMapKit.h>


@interface WaitView : BaseView

@property (nonatomic, strong) UILabel *label1;

@property (nonatomic, strong) UILabel *label2;

@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) BMKMapView *mapView;

@end
