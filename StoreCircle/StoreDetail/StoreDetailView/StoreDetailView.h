//
//  StoreDetailView.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"
@class CustomSDetailView;
@class StoreDetailModel;
@interface StoreDetailView : BaseView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollUp;

@property (nonatomic, strong) UILabel *introduce;

@property (nonatomic, strong) CustomSDetailView *address;

@property (nonatomic, strong) CustomSDetailView *tele;

@property (nonatomic, strong) UIScrollView *scrollDown;

@property (nonatomic, strong) NSMutableArray *scrollArray;

@property (nonatomic, strong) NSMutableArray *picArray;

//数据字典
@property (nonatomic, strong) StoreDetailModel *dataModel;


//上图片数组
@property (nonatomic, strong) NSMutableArray *upPicArray;

@property (nonatomic, strong) NSMutableArray *downPicArray;


- (void)createDetailView;


@end
