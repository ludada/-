//
//  InputViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "InputViewController.h"
#import "InputModel.h"
#import "InputButton.h"
#import "UIImageView+WebCache.h"
#import "WaitView1ViewController.h"
#import "WaitViewController.h"
#import "VoiceSendView.h"
#import "NSString+DocumentPath.h"
#import "VoiceConverter.h"
#import "LoginViewController.h"
#import "NetworkRequest.h"
#import "GlobalMacro.h"
#import "URLMacro.h"

@interface InputViewController ()<UITextViewDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) VoiceSendView *voiceImg;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) NSInteger voiceTime;

@end



@implementation InputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
   self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.messageArry=[NSMutableArray array];
        self.backButton=YES;
        self.isSend=YES;
    }
    return self;
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"快跑兄弟";
    [self.view setBackgroundColor:BackGray];

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 195 - 64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
    [self.tableView addGestureRecognizer:tap];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:@"cell1"];

    
    self.inputView=[[InputView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, SCREEN_WIDTH, 195)];
    [self.inputView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.inputView];
    self.inputView.textView.delegate=self;
    [self.inputView.sendMessage addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.voice addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.confirm addTarget:self action:@selector(isLogin1) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.sendVoice addTarget:self action:@selector(startRecordMp3:) forControlEvents:UIControlEventTouchDown];
    [self.inputView.sendVoice addTarget:self action:@selector(stopRecordMp3:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.sendVoice addTarget:self action:@selector(handleSwipeFrom:) forControlEvents:UIControlEventTouchDragExit];
    [self.inputView.cancle addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside] ;
    self.isVoice=YES;
    
    [self.messageArry addObject:self.model];
    [self.tableView reloadData];
    
    self.voiceImg=[[VoiceSendView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/3-50, SCREEN_WIDTH/2, SCREEN_HEIGHT/4)];
    
    
//    UISwipeGestureRecognizer *recognizer;
//    
//    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
////    [self.inputView.sendVoice addGestureRecognizer:recognizer];
    
}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble=[UIImage imageNamed:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg"];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    NSLog(@"%f,%f",size.width,size.height);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
    
    //根据语音长度
    int yuyinwidth = 66+logntime;
    
//    InputButton *button = [InputButton buttonWithType:UIButtonTypeCustom];
        InputButton *button = [[InputButton alloc]initWithFrame:CGRectMake(position, 10, yuyinwidth, 54)];

    button.tag = indexRow+100;
    if(fromSelf)
        button.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        button.frame =CGRectMake(position, 10, yuyinwidth, 64);
    
    //image偏移量
//    UIEdgeInsets imageInsert;
//    imageInsert.top = -10;
//    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
//    button.imageEdgeInsets = imageInsert;
//    
//    
//    
//    [button setImage:[UIImage imageNamed:@"ReceiverVoice"] forState:UIControlStateNormal];
    [button.voice setImage:[UIImage imageNamed:@"ReceiverVoice"]];
    UIImage *backgroundImage = [UIImage imageNamed:@"ReceiverVoiceDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d''",logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
//    button.tag=indexRow;
    [button addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:label];
    
    
    return button;
}



#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InputModel *model=self.messageArry[indexPath.row];
    if ([model.flag isEqualToString:@"1"]) {
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [model.content sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height+44;
    } else {
        return 64;
    }
   

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }
    [cell.contentView setBackgroundColor:BackGray];
    UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [photo setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headImg"] ] placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
   // photo.image=[UIImage imageNamed:@"kuaipaob"];
    [cell addSubview:photo];
    NSLog(@"%ld", indexPath.row);
    InputModel *model=self.messageArry[indexPath.row];
    if ([model.flag isEqualToString:@"1"]) {
        [cell addSubview:[self bubbleView:model.content from:NO withPosition:65]];
        NSLog(@"%f cell",cell.frame.size.height);

    } else {
        UIView *button=[self yuyinView:model.voiceTime from:NO withIndexRow:indexPath.row withPosition:65];
        button.tag=indexPath.row+100;
        [cell addSubview:button];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InputModel *model=[[InputModel alloc]init];
    if ([model.flag isEqualToString:@"0"]) {
       // [self playAction:model.content];
    }
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputView.textView resignFirstResponder];
}

#pragma mark - 按钮点击事件
//发送消息
- (void)sendMessageAction{
    if (self.inputView.textView.text==nil||[self.inputView.textView.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"消息不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    NSLog(@"selfmessage %ld",self.messageArry.count);
    InputModel *model=[[InputModel alloc]init];
    model.flag=@"1";
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    model.addTime = [formatter stringFromDate:[NSDate date]];
    model.content=self.inputView.textView.text;
    model.voiceTime=0;
    
    if (self.messageArry.count<3) {
        [self.messageArry addObject:model];
         self.inputView.textView.text=@"";
        [self.tableView reloadData];

    } else {
        [self.messageArry removeObjectAtIndex:0];
        [self.messageArry addObject:model];
        self.inputView.textView.text=@"";

        [self.tableView reloadData];
    }
    
}
- (void)voiceAction{
    self.inputView.textView.text=@"";
    if (self.isVoice==NO) {
        self.isVoice=YES;
        self.inputView.sendMessage.hidden = YES;
        [self.inputView.voice setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
        [self.inputView.textView removeFromSuperview];
        [self.inputView addSubview:self.inputView.sendVoice];
    } else {
        self.isVoice=NO;
        self.inputView.sendMessage.hidden = NO;
        [self.inputView.voice setBackgroundImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        [self.inputView.sendVoice removeFromSuperview];
        [self.inputView addSubview:self.inputView.textView];

    }
    
}
// 播放音频
- (void)playAction:(InputButton *)button{
    
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

    
    if(self.player.isPlaying){
        
        [self.player stop];
    }
    //播放
//    NSString *filePath=@"/Users/amy/Desktop/my.wav";
    InputModel *model=[self.messageArry objectAtIndex:button.tag-100];
    NSURL *fileUrl=[NSURL fileURLWithPath:model.fileUrl];
    
    NSLog(@"model.content====>>>%@",model.fileUrl);
    [self initPlayer];
    NSError *error;
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:&error];
    [self.player setVolume:1];
    [self.player prepareToPlay];
    [self.player setDelegate:self];
    [self.player play];
//    [button setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying1"] forState:UIControlStateNormal];
    [button.voice setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying1"]];
    UIImage *backgroundImage = [UIImage imageNamed:@"ReceiverVoiceNodeDownloading1"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    
    
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
    self.isSend=YES;
    [self.inputView.sendVoice setBackgroundColor:[UIColor grayColor]];
    
    [self.inputView.sendVoice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.inputView.sendVoice setTitle:@"松开停止" forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.voiceImg];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVice) userInfo:nil repeats:YES];
    if(self.recording)return;
    
    self.recording=YES;
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
    
    
}

//停止录制音频
- (void) stopRecordMp3:(UIButton *)voice{
    
    [self.inputView.sendVoice setBackgroundColor:TabGray];
    
    [self.inputView.sendVoice setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.inputView.sendVoice setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.voiceImg removeFromSuperview];
    [self.timer invalidate];
    self.voiceTime=self.recorder.currentTime;
    InputModel *model=[[InputModel alloc]init];
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
    model.content=[data base64Encoding];
   // NSLog(@"%@ modelcontent",model.content);
    model.addTime = [formatter stringFromDate:[NSDate date]];
    model.flag=@"0";
    model.fileUrl=self.fileUrl;
    model.voiceTime=self.recorder.currentTime;
    
    self.recording=NO;
    
    
    if (self.recorder.currentTime > 1.50) {
       // [self.navigationController pushViewController:input animated:YES];
        if (self.isSend==NO) {
            //return;
            NSLog(@"cancel");
        }else{
            
            if (self.messageArry.count<3) {
                [self.messageArry addObject:model];
                [self.tableView reloadData];
            } else {
                [self.messageArry removeObjectAtIndex:0];
                [self.messageArry addObject:model];
                [self.tableView reloadData];
                
            }
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"录音时间短" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
    }
    
    [self.recorder stop];
 
    self.recorder=nil;

    
    

    
}

//确认订单
- (void)confirmAction{
    
    self.view.userInteractionEnabled = NO;
    
    [LoadIndicator addIndicatorInView:self.view];
    
    if (self.messageArry.count==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请输入消息后发送" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    
    if (self.messageArry.count==1) {
        InputModel *model=[[InputModel alloc]init];
        model.flag=@"-1";
        model.content=@"";
        model.addTime=@"";
        model.voiceTime=0;
        InputModel *model2=[[InputModel alloc]init];
        model2.flag=@"-1";
        model2.content=@"";
        model2.addTime=@"";
        model2.voiceTime=0;
        [self.messageArry addObject:model];
        [self.messageArry addObject:model2];

    }
    if (self.messageArry.count==2) {
        
        InputModel *model=[[InputModel alloc]init];
        model.flag=@"-1";
        model.content=@"";
        model.addTime=@"";
        model.voiceTime=0;
        [self.messageArry addObject:model];
    }
    NSLog(@"selfMessage%@",self.messageArry);
    
    InputModel *model1=self.messageArry[0];

    InputModel *model2=self.messageArry[1];

    InputModel *model3=self.messageArry[2];
//    123.57.222.175
    
    NSString *url=@"http://123.57.222.175:8080/runfast/OrderAction!orderAdd.action?";
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"id"]=[user objectForKey:@"userId"];
    param[@"type"]=self.type;
    
    param[@"flag1"]=model1.flag;
    param[@"content1"]=model1.content;
    NSLog(@"%@  model1",model1.content);
    param[@"addTime1"]=model1.addTime;
    param[@"timeSpan1"]=[NSString stringWithFormat:@"%ld",(long)model1.voiceTime];
    
    param[@"flag2"]=model2.flag;
    param[@"content2"]=model2.content;
    param[@"addTime2"]=model2.addTime;
    param[@"timeSpan2"]=[NSString stringWithFormat:@"%ld",(long)model2.voiceTime];

    param[@"flag3"]=model3.flag;
    param[@"content3"]=model3.content;
    param[@"addTime3"]=model3.addTime;
    param[@"timeSpan3"]=[NSString stringWithFormat:@"%ld",(long)model3.voiceTime];

    param[@"longitude"]=self.longitude;
    param[@"latitude"]=self.latitude;
    
    
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:param ResponseBlock:^(id result) {
        NSLog(@"%@ result",result);
        NSDictionary *dic=[[result objectForKey:@"msg"] firstObject];
        if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"发布成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            WaitViewController *waitView=[[WaitViewController alloc]init];
            waitView.ordersId=[dic objectForKey:@"ordeId"];
            waitView.jingdu=self.longitude;
            waitView.weidu=self.latitude;

//            [self.messageArry removeAllObjects];
            
            [self.navigationController pushViewController:waitView animated:YES];

        }
        else
        {
            
            
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"发布失败" message:@"重新发布吧" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
//            [self.messageArry removeAllObjects];

            

        }
        
        self.view.userInteractionEnabled = YES;
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        NSLog(@"%@ error",error);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接出现错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];

        self.view.userInteractionEnabled = YES;
        [LoadIndicator stopAnimationInView:self.view];

    }];
    
    
}

- (void)buttonAction:(id)sender
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.hideTab = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    [self.messageArry removeAllObjects];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.messageArry];
    if (self.messageArry.count > 0) {
        for (InputModel *model in array) {
            if (model.voiceTime == 0 && [model.flag isEqualToString:@"-1"] && [model.content isEqualToString:@""]) {
                [self.messageArry removeObject:model];
            }
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.inputView.frame = CGRectMake(0,SCREEN_HEIGHT - 400, SCREEN_WIDTH, SCREEN_HEIGHT*1/3);
    } completion:nil];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT*1/3);
    } completion:nil];
}
- (void)detectionVice{
    
    [self.recorder updateMeters];//刷新音量
    double lowPassResults=pow(10, (0.05*[self.recorder peakPowerForChannel:0]));
    NSLog(@"%f dfaafafd",lowPassResults);
    
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
- (void)handleSwipeFrom:(id)sender{
    self.isSend=NO;
    [self stopRecordMp3:nil];
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
        [self  confirmAction];
        
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



//取消发布订单
- (void)cancleOrder{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - audioplayer代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.tableView reloadData];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
}
@end
