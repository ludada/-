//
//  GlobalMacro.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//
#import "GlobalMethod.h"

#pragma mark - 定义所有的宏 (除了url)

/*****屏幕宽度和高度*****/

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//定义颜色
//所有的灰色(背景颜色)
#define BackGray [GlobalMethod hexStringToColor:@"#fafafa"]
//字体的灰色
#define FontGray [GlobalMethod hexStringToColor:@"#cccccc"]
//白色
#define White [GlobalMethod hexStringToColor:@"#ffffff"]
//绿色(tab)
#define Green [GlobalMethod hexStringToColor:@"#17cd57"]
//tab和语音灰色
#define TabGray [GlobalMethod hexStringToColor:@"#eeeeee"]
//蓝色 segmentControl 选择性别
#define Blue [GlobalMethod hexStringToColor:@"#17a5e7"]
//红色 segmentControl
#define red [GlobalMethod hexStringToColor:@"#f76b73"]
#define coinColor [GlobalMethod hexStringToColor:@"#ff7e00"]


/*判断手机型号*/
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)