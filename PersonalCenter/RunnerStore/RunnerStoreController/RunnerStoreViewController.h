//
//  RunnerStoreViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"
@class RunnerStoreView;
@interface RunnerStoreViewController : BaseViewController

@property (nonatomic, strong) RunnerStoreView *runnerStore;

@property (nonatomic, strong) NSMutableArray *collectArray;

@end
