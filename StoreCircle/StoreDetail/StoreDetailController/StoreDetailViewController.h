//
//  StoreDetailViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"
@class StoreDetailView;
@interface StoreDetailViewController : BaseViewController

@property (nonatomic, strong) StoreDetailView *detail;

@property (nonatomic, copy) NSString *storeDetailId;


@end