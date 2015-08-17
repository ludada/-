//
//  InputViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  语音界面

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "InputTableViewCell.h"
#import "InputModel.h"
#import "InputView.h"

@interface InputViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>


@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) AVAudioRecorder *recorder;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageArry;

@property (nonatomic, strong) InputView *inputView;

@property (nonatomic) BOOL isVoice;

@property (nonatomic) BOOL recording;

@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) NSString *fileUrl;

@property (nonatomic, strong) NSString *textFirst;

@property (nonatomic, strong) InputModel *model;
/**
 *  发送消息
 */
- (void) sendMessageAction;

/**
 *  语音按钮
 */
- (void) voiceAction;

/**
 *  确定按钮
 */
- (void) confirmAction;


@end
