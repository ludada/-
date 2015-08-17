//
//  RunnerStoreView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"
@class CustomItemButton;
@interface RunnerStoreView : BaseView<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *picArray;

@property (nonatomic, strong) UILabel *coin;

@property (nonatomic, strong) UIButton *getCoin;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) UIPageControl *page;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, strong) UIView *downView;

@property (nonatomic, strong) CustomItemButton *localLife;

@property (nonatomic, strong) CustomItemButton *shopping;

@property (nonatomic, strong) UIButton *myView;


@property (nonatomic, copy) NSString *myCoin;

@property (nonatomic, strong) UIButton *how;

- (void)setTimer;

- (void)createRunnerStore;

- (void)createCollectionView;

@end
