//
//  RegistNextViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "BaseViewController.h"

#import "VPImageCropperViewController.h"

@class RegistNextView;

@interface RegistNextViewController : BaseViewController

@property (nonatomic, strong) RegistNextView *next;

@property (nonatomic, strong) NSString *myTel;

@property (nonatomic, strong) NSString *password;

//保存图片信息
@property (nonatomic, strong) NSDictionary *dic;

//照片数据
@property (nonatomic, strong) NSString *imageBase64;


@property (nonatomic) BOOL nickName;

@property (nonatomic) BOOL address;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *areaId;


@end
