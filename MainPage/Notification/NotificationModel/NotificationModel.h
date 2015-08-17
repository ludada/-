//
//  NotificationModel.h
//  FasterRunner
//
//  Created by HLKJ on 15/5/28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//{"addTime":"2015-05-13","content":"杩欐槸鍐呭1鎾掓棪娉曠涓夋柟闃挎柉椤跨Н鍒嗗崱鏁伴噺灏嗛潪娉曡繘鍙ｆ暟閲忕殑闄勪欢鏄墦寮�鎴块棿鐪嬪埌鏄埌浠樺揩閫掕垂闃挎柉椤块鏈�","endTime":"2015-05-13","id":"1","instructions":"璇存槑1","msgId":"434","startTime":"2015-05-13","tag":"0","title":"鏍囬1","type":"1"}
//msgId:消息记录表id （用于单个删除时 传给我的id）
//id：通知id
//title:标题
//content:内容
//instructions:说明
//type:标示 1=消息 2=代金券
//addTime:添加时间
//startTime:开始时间
//endTime:结束时间

//

#import "BaseModel.h"

@interface NotificationModel : BaseModel

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *addTime;

@property (nonatomic, strong) NSString *msgId;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *startTime;

@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) NSString *instructions;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *tag;

@property (nonatomic, strong) NSString *flag;

@end
