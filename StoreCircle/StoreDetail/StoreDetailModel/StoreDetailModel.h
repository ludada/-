//
//  StoreDetailModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseModel.h"

@interface StoreDetailModel : BaseModel

@property (nonatomic, copy) NSString *storId;

@property (nonatomic, copy) NSString *circId;

@property (nonatomic, copy) NSString *signaImg;

@property (nonatomic, copy) NSString *signaLink;

@property (nonatomic, copy) NSString *storName;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *storDesc;

@property (nonatomic, copy) NSString *storAddTime;

@property (nonatomic, copy) NSString *circName;

@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, copy) NSString *circDesc;

//八张照片  都好分割
@property (nonatomic, copy) NSString *minImg;

@property (nonatomic, copy) NSString *maxImg;

@end
