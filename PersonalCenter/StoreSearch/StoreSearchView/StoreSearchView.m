//
//  StoreSearchView.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreSearchView.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
#import "RunnerStoreCollectionViewCell.h"
@implementation StoreSearchView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createSearchView
{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 5;
    searchView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    searchView.layer.borderWidth = 0.3;
    [self addSubview:searchView];
    
    
    self.content = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, searchView.frame.size.width - 60, 20)];
    [self.content setPlaceholder:@"请输入您要搜索的内容"];
    [self.content setFont:[UIFont systemFontOfSize:13]];
    [searchView addSubview:self.content];
    
    
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(searchView.frame.size.width - 50, 0, 50, 30)];
    [self.searchButton setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:self.searchButton];
    
    
    self.search = [[UIButton alloc] initWithFrame:CGRectMake(searchView.frame.size.width - 30, 7.5, 18, 15)];
    [self.search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchView addSubview:self.search];
    
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setItemSize:CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2)];
    [flow setMinimumInteritemSpacing:5];
    [flow setMinimumLineSpacing:5];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flow setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, searchView.frame.size.height + searchView.frame.origin.y + 10, SCREEN_WIDTH, SCREEN_HEIGHT - (searchView.frame.size.height + searchView.frame.origin.y + 10 + 64)) collectionViewLayout:flow];
    [self.collectView registerClass:[RunnerStoreCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.collectView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.collectView];
    
}



@end
