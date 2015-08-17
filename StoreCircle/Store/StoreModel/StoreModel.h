//
//  StoreModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseModel.h"

@interface StoreModel : BaseModel

//少个距离?

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *adress;

@property (nonatomic, copy) NSString *busiTime;

@property (nonatomic, copy) NSString *phone;


@end
