//
//  StoreSearchView.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseView.h"

@interface StoreSearchView : BaseView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *content;

@property (nonatomic, strong) UIButton *search;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UICollectionView *collectView;


- (void)createSearchView;

@end
