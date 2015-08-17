//
//  ShopSearchView.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-19.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "ShopSearchView.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
#import "StoreTableViewCell.h"
@implementation ShopSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.tableView registerClass:[StoreTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.tableView];
}


@end
