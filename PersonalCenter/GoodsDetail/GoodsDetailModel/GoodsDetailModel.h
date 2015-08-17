//
//  GoodsDetailModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsDetailModel : BaseModel

@property (nonatomic, copy) NSString *minImg;

//商品id
@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSNumber *points;

@end
