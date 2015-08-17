//
//  AboutRunnerViewController.m
//  FasterRunnerServer
//
//  Created by HLKJ on 15-5-11.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "AboutRunnerViewController.h"
#import "NetworkRequest.h"
#import "GlobalMacro.h"


@interface AboutRunnerViewController ()<UIWebViewDelegate>

@end

@implementation AboutRunnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton=YES;
    }
    return self;
    
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationItem.title=@"关于快跑";
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [image setImage:[UIImage imageNamed:@"icon22"]];
    image.layer.cornerRadius = 7;
    image.layer.masksToBounds = YES;
    [self.view addSubview:image];
    image.center = CGPointMake(self.view.center.x, 100);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.origin.x, image.frame.origin.y + image.frame.size.height + 20, image.frame.size.width, 30)];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height + 20, label.frame.size.width, 20)];
    [version setFont:[UIFont systemFontOfSize:15]];
    [version setTextAlignment:NSTextAlignmentCenter];
    [version setTextColor:[UIColor grayColor]];
    [self.view addSubview:version];
    
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(40, version.frame.size.height + version.frame.origin.y + 50, SCREEN_WIDTH - 80, 100)];
    [desc setText:@"   快跑兄弟APP软件, 由沈阳麦思科技有限公司研发,\n是国内首家运营兼跑腿与本地便民服务及商圈团购等\n业务为一体的手机软件平台"];
    [desc setTextAlignment:NSTextAlignmentCenter];
    [desc setFont:[UIFont systemFontOfSize:15]];
    [desc setNumberOfLines:0];
    [self.view addSubview:desc];
    
    
    
    
}
@end
