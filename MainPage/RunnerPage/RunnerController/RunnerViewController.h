//
//  RunnerViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  快跑主页面

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import "GlobalMacro.h"
#import "InputModel.h"
#import "VoiceConverter.h"
#import "GlobalMethod.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKAnnotation.h>
#import <AVFoundation/AVFoundation.h>

@interface RunnerViewController : BaseViewController<CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,AVAudioRecorderDelegate>

@property (nonatomic, strong) UIView *runnerView;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManger;

@property (nonatomic, strong) UIButton *runFast;

@property (nonatomic, strong) UIButton *takeTaxi;

@property (nonatomic, strong) UILabel *runLabel;

@property (nonatomic, strong) UILabel *takeLabel;

@property (nonatomic, strong) UIButton *voice;

@property (nonatomic, strong) UIButton *confirm;

@property (nonatomic, strong) UIButton *luyin;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, strong) NSString *longitude;

//@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic)BOOL isLuyin;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) NSString *fileUrl;

@property (nonatomic, assign) BOOL recording;



//添加自己的位置
//- (void) addLocation;
//快跑按钮事件
- (void) runfasterAction;
//出租车按钮事件
- (void) taketaxiAction;
//语音事件
- (void) yuyinAction;
//发送语音
- (void) takeTextAction;
@end
