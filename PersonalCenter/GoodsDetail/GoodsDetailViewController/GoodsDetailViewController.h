//
//  GoodsDetailViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsDetailView.h"
@class PurchaseView;
@interface GoodsDetailViewController : BaseViewController

@property (nonatomic, strong) GoodsDetailView *goods;

@property (nonatomic, strong) NSString *goodsId;

@property (nonatomic, strong) PurchaseView *purchase;

@property (nonatomic, copy) NSString *coins;
@end
