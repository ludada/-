//
//  StoreView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"

@interface StoreView : BaseView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) UIPageControl *page;

@property (nonatomic, strong) UIButton *myView1;

//轮番滚动定时器
@property (nonatomic, strong) NSTimer *timer;


/**
 *  存放图片标题数组
 */
@property (nonatomic, strong) NSMutableArray *picArray;

/**
 *  存放商圈数据列表数据数组
 */

@property (nonatomic, strong) NSMutableArray *infoArray;

/**
 *  存放商圈类型列表数据数组
 */

@property (nonatomic, strong) NSMutableArray *typeArray;




/********************/




//tableview
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *buttonArray;

- (void)createStoreView;

- (void)setTimer;

@end
