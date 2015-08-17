//
//  ChangeViewController.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//  修改用户界面

#import "BaseViewController.h"
#import "ChangeView.h"
#import "InfoChangeButton.h"
#import "VPImageCropperViewController.h"
@interface ChangeViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, VPImageCropperDelegate,UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate>


@property (nonatomic, strong) ChangeView *headView;

@property (nonatomic, strong) InfoChangeButton *nickName;

@property (nonatomic, strong) InfoChangeButton *sex;

@property (nonatomic, strong) InfoChangeButton *area;

@property (nonatomic, strong) InfoChangeButton *birth;

@property (nonatomic, strong) UIButton *finish;

@property (nonatomic, strong) NSDictionary *dic;
;
@property (nonatomic, strong) NSString *imageBase64;


@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIView *myView;

@property (nonatomic, strong) UIPickerView *regionPicker;

@property (nonatomic, strong) UIImage *img;

@property (nonatomic, strong) NSString *adresId;


//保存省市区的数组；
@property (nonatomic, strong) NSMutableArray *regionArray;

// 修改头像
- (void) headImgAction:(id)sender;

//修改昵称
- (void) changeNickAciton;

//修改性别
- (void) changeSexAction;

//修改地区
- (void) changeAreaAction;

//修改出生日期
- (void) changeBirthAction;

//确定
- (void) finishAction;

//获取用户资料
- (void) getCustomerInfo;
@end
