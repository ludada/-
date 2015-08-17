//
//  RunnerViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RunnerViewController.h"
#import "NetworkRequest.h"
#import "URLMacro.h"
#import "LoginViewController.h"
#import "VoiceSendView.h"
#import "NSString+DocumentPath.h"
#import "InputViewController.h"
#import "NotificationViewController.h"
#import "Singleton.h"

@interface RunnerViewController()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic)CGFloat latitudes;
@property (nonatomic)CGFloat longitudes;
@property (nonatomic, strong) BMKPointAnnotation *annotation;
@property (nonatomic, strong) VoiceSendView *voiceImg;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) InputModel *model;
@property (nonatomic,assign) BOOL isSend;

@end

@implementation RunnerViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isSend=YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PRESENT" object:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //推送系统通知跳转页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentAction:) name:@"PRESENT" object:nil];
    

     self.navigationItem.title=@"快跑兄弟";
    
//    UIImage *image = [UIImage imageNamed:@"aaa"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(notificationAction:)];
    
    _locationManger=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    Singleton *share = [Singleton shareInstance];
    
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
      //  [_locationManger requestWhenInUseAuthorization];
        
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        
  
        share.locService = [[BMKLocationService alloc]init];
        //初始化BMKLocationService

        share.locService.delegate = self;
        //启动LocationService
        [share.locService startUserLocationService];

    }else{
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        
        
        share.locService = [[BMKLocationService alloc]init];
        //初始化BMKLocationService
        
        share.locService.delegate = self;
        //启动LocationService
        [share.locService startUserLocationService];
    }
    
    self.isLuyin=YES;
    self.type=@"1";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
    [self.mapView addGestureRecognizer:tap];
    
    [self createView];
    
   // [self textMapChange];
    
    [self.runFast addTarget:self action:@selector(runfasterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.takeTaxi addTarget: self action:@selector(taketaxiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.voice addTarget:self action:@selector(yuyinAction) forControlEvents:UIControlEventTouchUpInside];
 
    [self.luyin addTarget:self action:@selector(startRecordMp3:) forControlEvents:UIControlEventTouchDown];
    [self.luyin addTarget:self action:@selector(stopRecordMp3:) forControlEvents:UIControlEventTouchUpInside];
    [self.luyin addTarget:self action:@selector(yuyinDragged) forControlEvents:UIControlEventTouchDragExit];

    [self.confirm addTarget:self action:@selector(isLogin6) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //第一次注册发送代金卷
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"registFirst"] isEqualToString:@"1"]) {
        
    }
    
    

}

//拖拽取消
- (void)yuyinDragged
{
    self.isSend=NO;
    [self stopRecordMp3:nil];
}



- (void)createView{
    self.runnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.runnerView];
    
   
    
    
    self.mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3-64)];
    self.mapView.mapType=MKMapTypeStandard;
    self.mapView.zoomLevel=14;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.runnerView addSubview:self.mapView];
    
    self.runFast=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, self.mapView.frame.size.height+SCREEN_WIDTH/10, SCREEN_WIDTH/10, SCREEN_WIDTH/10)];
    [self.runFast setBackgroundImage:[UIImage imageNamed:@"kuaipaob"] forState:UIControlStateNormal];
    [self.runnerView addSubview:self.runFast];
    
    self.runLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *3/10, self.mapView.frame.size.height+SCREEN_WIDTH/10+10, SCREEN_WIDTH/10, 16)];
    self.runLabel.text=@"快跑";
    self.runLabel.font=[UIFont systemFontOfSize:11];
    [self.runnerView addSubview:self.runLabel];
    
    [GlobalMethod drawLineWithFrame:CGRectMake(SCREEN_WIDTH *2/5, self.mapView.frame.size.height+SCREEN_WIDTH/10+SCREEN_WIDTH/20, SCREEN_WIDTH/5, 1) inView:self.runnerView];
    
    self.takeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*11/15, self.runLabel.frame.origin.y, SCREEN_WIDTH/10, 16)];
    self.takeLabel.font=[UIFont systemFontOfSize:11];
    self.takeLabel.text=@"打车";
    [self.runnerView addSubview:self.takeLabel];
    
    [self.runLabel setTextColor:Green];
    
    self.takeTaxi=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/5+5, self.mapView.frame.size.height+SCREEN_WIDTH/10+2, SCREEN_WIDTH/10-6, SCREEN_WIDTH/10-6)];

    [self.takeTaxi setBackgroundImage:[UIImage imageNamed:@"dacheb"] forState:UIControlStateNormal];
    [self.runnerView addSubview:self.takeTaxi];
    
    self.voice=[[UIButton alloc]initWithFrame:CGRectMake(20, self.runFast.frame.size.height+self.runFast.frame.origin.y+SCREEN_WIDTH/10-20, SCREEN_WIDTH/6, SCREEN_WIDTH/10)];
    [self.voice setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
    [self.runnerView addSubview:self.voice];
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, self.runFast.frame.size.height+self.runFast.frame.origin.y+SCREEN_WIDTH/10-20, SCREEN_WIDTH/2, SCREEN_WIDTH/10)];
    self.textField.placeholder=@"输入文字";
    self.textField.delegate  = self;
    self.textField.borderStyle=UITextBorderStyleRoundedRect;
   // [self.runnerView addSubview:self.textField];
    
    self.luyin=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, self.runFast.frame.size.height+self.runFast.frame.origin.y+SCREEN_WIDTH/10-20, SCREEN_WIDTH/2 + 55, SCREEN_WIDTH/10)];
    self.luyin.backgroundColor = [UIColor whiteColor];
    [self.luyin setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.luyin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.luyin.layer.cornerRadius = 5;
    self.luyin.layer.masksToBounds = YES;
    self.luyin.layer.borderWidth = 0.5;
    self.luyin.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
    [self.runnerView addSubview:self.luyin];
    self.confirm=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4+10,  self.runFast.frame.size.height+self.runFast.frame.origin.y+SCREEN_WIDTH/10-20, SCREEN_WIDTH/6, SCREEN_WIDTH/10)];
    [self.confirm.layer setCornerRadius:5];
    [self.confirm setBackgroundColor:Green];
    [self.confirm setTitle:@"发送" forState:UIControlStateNormal];
    [self.runnerView addSubview:self.confirm];
    self.confirm.hidden = YES;
    
    
    self.voiceImg=[[VoiceSendView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/3, SCREEN_WIDTH/2, SCREEN_HEIGHT/4)];
   // [self.view addSubview:self.voiceImg];
    self.annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = self.latitudes;
    coor.longitude = self.longitudes;
    self.annotation.coordinate = coor;
    self.annotation.title = @"您的位置";
    [_mapView addAnnotation:self.annotation];

    
     [GlobalMethod drawLineWithFrame:CGRectMake(0, self.mapView.frame.size.height + self.mapView.frame.origin.y, SCREEN_WIDTH, 0.5) inView:self.runnerView];
    
}

- (void)notificationAction:(id)sender
{
    UIImage *image = [UIImage imageNamed:@"aaa"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(notificationAction:)];
    
    NotificationViewController *notifi = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notifi animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    Singleton *share = [Singleton shareInstance];
    share.locService.delegate=self;
    self.hideTab = NO;
    
    
 
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [_mapView viewWillDisappear];
    Singleton *share = [Singleton shareInstance];

    _mapView.delegate=nil;
    share.locService.delegate=nil;
    [share.locService stopUserLocationService];
    
}

#pragma mark - 将要启动
- (void)willStartLocatingUser
{
    NSLog(@"start = = = ");
}

#pragma mark - 定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitudes=userLocation.location.coordinate.latitude;
    self.longitudes=userLocation.location.coordinate.longitude;
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    
  //  [_mapView removeAnnotation:self.annotation];
    
  
}



#pragma mark -地图代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}






#pragma mark -按钮点击事件

- (void)runfasterAction
{
    self.runFast.frame=CGRectMake(SCREEN_WIDTH/6, self.mapView.frame.size.height+SCREEN_WIDTH/10, SCREEN_WIDTH/10, SCREEN_WIDTH/10);
    
    [self.runFast setBackgroundImage:[UIImage imageNamed:@"kuaipaob"] forState:UIControlStateNormal];

    self.takeTaxi.frame=CGRectMake(SCREEN_WIDTH*3/5+5, self.mapView.frame.size.height+SCREEN_WIDTH/10+2, SCREEN_WIDTH/10-6, SCREEN_WIDTH/10-6);
    [self.takeTaxi setBackgroundImage:[UIImage imageNamed:@"dacheb"] forState:UIControlStateNormal];
    
    [self.runLabel setTextColor:Green];
    [self.takeLabel setTextColor:FontGray];
    self.type=@"1";


}

- (void)taketaxiAction
{

    
    self.runFast.frame=CGRectMake(SCREEN_WIDTH/6, self.mapView.frame.size.height+SCREEN_WIDTH/10+2, SCREEN_WIDTH/10-6, SCREEN_WIDTH/10-6);
    
    [self.runFast setBackgroundImage:[UIImage imageNamed:@"kuaipaoa"] forState:UIControlStateNormal];
    [self.runLabel setTextColor:FontGray];
    [self.takeLabel setTextColor:Green];
    self.takeTaxi.frame=CGRectMake(SCREEN_WIDTH*3/5+5, self.mapView.frame.size.height+SCREEN_WIDTH/10, SCREEN_WIDTH/10, SCREEN_WIDTH/10);
    [self.takeTaxi setBackgroundImage:[UIImage imageNamed:@"dachea"] forState:UIControlStateNormal];
    self.type=@"2";
    
    
}

- (void)yuyinAction{
//    InputViewController *input=[[InputViewController alloc]init];
//    [self.navigationController pushViewController:input animated:YES];
    if (self.isLuyin) {
        self.isLuyin=NO;
        self.confirm.hidden = NO;
        [self.luyin removeFromSuperview];
        [self.voice setBackgroundImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        [self.runnerView addSubview:self.textField];
        
    }else{
        self.confirm.hidden = YES;
        self.isLuyin=YES;
        [self.textField removeFromSuperview];
        self.textField.text=@"";
        [self.view addSubview:self.luyin];
        [self.voice setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        
    }
    
    
}

- (void)takeTextAction{
    [self.view endEditing:YES];
    if ([self.textField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"消息不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        return;
        
    }
    self.model=[[InputModel alloc]init];
    self.model.content=self.textField.text;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    self.model.addTime = [formatter stringFromDate:[NSDate date]];
    self.model.flag=@"1";
    self.model.voiceTime=0;
    self.model.fileUrl=@"";
    InputViewController *input=[[InputViewController alloc]init];
    input.model=self.model;
    input.longitude=[NSString stringWithFormat:@"%f",self.longitudes];
    input.latitude=[NSString stringWithFormat:@"%f",self.latitudes];
    input.type=self.type;
    input.textFirst=self.textField.text;
    NSLog(@"self.long %f",self.longitudes);
    self.textField.text=@"";
    [self.navigationController pushViewController:input animated:YES];
    

    
}




- (void)buttonAction:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark -  输入框高度改变
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.runnerView.frame = CGRectMake(0, - 210, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}
#pragma mark - 结束编辑时键盘还原
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        self.runnerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
}


//初始化音频播放器
-(void)initPlayer{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}
//开始录制音频
- (void) startRecordMp3:(UIButton *)voice{
    [self.luyin setBackgroundColor:[UIColor grayColor]];
    if(self.recording)return;
    self.isSend=YES;
    self.recording=YES;
    
    [self.luyin setTitle:@"松开停止" forState:UIControlStateNormal];
    [self.luyin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"rec_%@.wav",[dateFormater stringFromDate:now]];
    self.fileName=fileName;
    self.fileUrl=[NSString documentPathWith:fileName];
    NSLog(@"%@,filename",self.fileUrl);
    NSURL *fileUrl=[NSURL fileURLWithPath:self.fileUrl];
    
    NSError *error;
    self.recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder peakPowerForChannel:0];
    [self.recorder record];
    [self.view addSubview:self.voiceImg];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVice) userInfo:nil repeats:YES];
    
    
}

//停止录制音频
- (void) stopRecordMp3:(UIButton *)voice{
    [self.luyin setBackgroundColor:[UIColor whiteColor]];
    [self.voiceImg removeFromSuperview];
    [self.timer invalidate];
    
    [self.luyin setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.luyin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.model=[[InputModel alloc]init];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    
    //amr的名字
    NSString *amrName=[NSString stringWithFormat:@"%@.amr", [dateFormater stringFromDate:[NSDate date]]];
    //存放amr文件的本地地址
    NSString *amrUrl=[NSString documentPathWith:amrName];
    NSLog(@"armurl ===%@",amrUrl);
    //wav转换成amr
    [VoiceConverter wavToAmr:self.fileUrl amrSavePath:amrUrl];
    NSString *path=[@"file://" stringByAppendingString:amrUrl];
    //amr文件转换成base64
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
   self.model.content=[data base64Encoding];
    // NSLog(@"%@ modelcontent",model.content);
    self.model.addTime = [formatter stringFromDate:[NSDate date]];
    self.model.flag=@"0";
    self.model.voiceTime=self.recorder.currentTime;
    self.model.fileUrl=self.fileUrl;
    self.recording=NO;

    if (self.isSend==NO) {
        return;
    }
    
    
    if (self.recorder.currentTime > 1.50) {
        
        InputViewController *input=[[InputViewController alloc]init];
        input.model=self.model;
        
        input.longitude=[NSString stringWithFormat:@"%f",self.longitudes];
        input.latitude=[NSString stringWithFormat:@"%f",self.latitudes];
        input.type=self.type;
        
        self.recorder=nil;
        
        [self performSelector:@selector(delayAction:) withObject:input afterDelay:0.3];
        


    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录音时间短" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        self.recorder=nil;

        
    }
    
   


    
}


- (void)delayAction:(InputViewController *)sender
{
    

    [self.navigationController pushViewController:sender animated:YES];

}


- (void)detectionVice{
    
    [self.recorder updateMeters];//刷新音量
    double lowPassResults=pow(10, (0.05*[self.recorder peakPowerForChannel:0]));
    NSLog(@"%fdfajldfaljl",lowPassResults);
    
    if (lowPassResults<=0.14) {
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"1"]];
    }
    else if (0.14<lowPassResults<=0.28){
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"2"]];
 
    }
    else if (0.28<lowPassResults<=0.42){
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"3"]];
        
    }
    else if (0.42<lowPassResults<=0.56){
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"4"]];
        
    }
    else if (0.56<lowPassResults<=0.70){
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"5"]];
        
    }
    else if (0.70<lowPassResults<=0.84){
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"6"]];
        
    }
    else{
        [self.voiceImg.volume setImage:[UIImage imageNamed:@"7"]];
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)isLogin1{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self   runfasterAction];
        
    } ErrorBlock:^(id error) {
        
        

    }];
   
    
}

- (void)isLogin2{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self taketaxiAction];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

- (void)isLogin3{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self yuyinAction];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

- (void)isLogin4{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self startRecordMp3:nil];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

- (void)isLogin5{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self stopRecordMp3:nil];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

- (void)isLogin6{
    
//    NSString *url=@"http://123.57.222.175:3306/runfast/UsersAction!usersOnline.action?";
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"type"]=@"1";
    dic[@"id"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [NetworkRequest netWorkRequestPOSTWithString:ONLINE Parameters:dic ResponseBlock:^(id result) {
        
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *tagId=[dic objectForKey:@"tagId"];
        NSString *tagid=[[NSUserDefaults standardUserDefaults]objectForKey:@"tagId"];
        if (![tagid isEqualToString:tagId]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账号在别的设备上登陆" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag=111;
            return;
            
        }
        [self takeTextAction];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==111) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user setObject:@"logout" forKey:@"logout"];
        
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:nil];

    }
}

#pragma mark - 系统消息

- (void)presentAction:(NSNotification *)notification
{
    NotificationViewController *noti = [[NotificationViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noti];
    noti.isNotification = YES;
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void)textMapChange{
    BMKMapPoint point11 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,115.404));
    BMKMapPoint point21 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.824,115.404));
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point11,point21);
    
    NSLog(@"%f distance",distance);
    if (distance<=50) {
        self.mapView.zoomLevel=19;
    }
    else if(distance<=125) {
        self.mapView.zoomLevel=18;
    }
    else if(distance<=250){
        self.mapView.zoomLevel=17;
    }
    else if(distance<=500){
        self.mapView.zoomLevel=16;
    }
    else if(distance<=1250){
        self.mapView.zoomLevel=15;
    }
    else if(distance<=2500){
        self.mapView.zoomLevel=14;
    }
    else if(distance<=5000){
        self.mapView.zoomLevel=13;
    }
    else if(distance<=12500){
        self.mapView.zoomLevel=12;
    }
    else if(distance<=25000){
        self.mapView.zoomLevel=11;
    }
    else if(distance<=50000){
        self.mapView.zoomLevel=10;
    }
    else{
        self.mapView.zoomLevel=9;
    }

}


@end
