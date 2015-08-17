//
//  ShopSearchViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-19.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"

@class ShopSearchView;

@interface ShopSearchViewController : BaseViewController

@property (nonatomic, strong) ShopSearchView *shop;

@property (nonatomic, strong) NSMutableArray *tableArray;

@end
