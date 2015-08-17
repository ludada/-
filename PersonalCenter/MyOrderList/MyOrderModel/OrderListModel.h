//
//  OrderListModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseModel.h"

@interface OrderListModel : BaseModel
@property (nonatomic, strong) NSString *addTime;

@property (nonatomic, strong) NSString *flag;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *orderCode;

@property (nonatomic, strong) NSString *realName;

@property (nonatomic, strong) NSString *type;

@end
