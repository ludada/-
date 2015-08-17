//
//  RunnerStoreModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseModel.h"

@interface RunnerStoreModel : BaseModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSNumber *points;

@property (nonatomic, copy) NSString *recommend;

@property (nonatomic, copy) NSString *pointsCount;

@end
