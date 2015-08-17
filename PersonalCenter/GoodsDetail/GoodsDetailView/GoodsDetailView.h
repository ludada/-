//
//  GoodsDetailView.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"
@class GoodsDetailModel;
@interface GoodsDetailView : BaseView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *page;

@property (nonatomic, strong) UILabel *coin;

@property (nonatomic, strong) UIButton *purchase;

@property (nonatomic, strong) UILabel *content;

//图片数组
@property (nonatomic, strong) NSMutableArray *picArray;

//scrollView下面的视图
@property (nonatomic, strong) UIView *downView;


//数据model
@property (nonatomic, strong) GoodsDetailModel *model;

- (void)createGoodsDetailView;

- (void)setTimer;


@end
