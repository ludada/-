//
//  InputModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseModel.h"

@interface InputModel : BaseModel

@property (nonatomic, strong) NSString *flag;

@property (nonatomic, strong) NSString *addTime;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *fileUrl;

@property (nonatomic, assign) NSInteger voiceTime;

@end
