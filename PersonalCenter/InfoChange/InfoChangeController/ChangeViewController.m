//
//  ChangeViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "ChangeViewController.h"
#import "GlobalMacro.h"
#import "URLMacro.h"
#import "LoginViewController.h"
#import "PersonalViewController.h"
#import "NetworkRequest.h"
#import "VPImageCropperViewController.h"
#import "NickNameViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LoadIndicator.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"


#define ORIGINAL_MAX_WIDTH 640.0f
@implementation ChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dic=[NSDictionary dictionary];
        self.backButton = YES;
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户信息 ";
    
    
    
    self.headView=[[ChangeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    [self.headView.headImg addTarget:self action:@selector(headImgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.headView];
    
    self.nickName=[[InfoChangeButton alloc]initWithFrame:CGRectMake(0, self.headView.frame.size.height + self.headView.frame.origin.y, SCREEN_WIDTH, 44)];
    self.nickName.label1.text=@"昵称";
    [self.nickName addTarget:self action:@selector(changeNickAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nickName];
    
    self.sex=[[InfoChangeButton alloc]initWithFrame:CGRectMake(0, self.nickName.frame.size.height + self.nickName.frame.origin.y, SCREEN_WIDTH, 44)];
    self.sex.label1.text=@"性别";
    [self.sex addTarget:self action:@selector(changeSexAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sex];
    
    self.birth=[[InfoChangeButton alloc]initWithFrame:CGRectMake(0, self.sex.frame.size.height + self.sex.frame.origin.y, SCREEN_WIDTH, 44)];
    self.birth.label1.text=@"出生日期";
    [self.birth addTarget:self action:@selector(changeBirthAction) forControlEvents:UIControlEventTouchUpInside];
    self.birth.label2.text=@"1991-06-23";
    [self.view addSubview:self.birth];
    
    self.area=[[InfoChangeButton alloc]initWithFrame:CGRectMake(0, self.birth.frame.size.height + self.birth.frame.origin.y, SCREEN_WIDTH, 44)];
    self.area.label1.text=@"地区";
    [self.area addTarget:self action:@selector(changeAreaAction) forControlEvents:UIControlEventTouchUpInside];
    self.area.label2.text=@"北京市";
    [self.view addSubview:self.area];
    
    self.finish=[[UIButton alloc]initWithFrame:CGRectMake(20, self.area.frame.size.height + self.area.frame.origin.y + 50, SCREEN_WIDTH-40, 50)];
    [self.finish.layer setCornerRadius:7];
    self.finish.layer.masksToBounds=YES;
    [self.finish setTitle:@"完成" forState:UIControlStateNormal];
    [self.finish setBackgroundImage:[UIImage imageNamed:@"Status_bar"] forState:UIControlStateNormal];
    [self.finish addTarget:self action:@selector(isLogin2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.finish];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createNickName:) name:@"createNickName" object:nil];
    
    [LoadIndicator addIndicatorInView:self.view];
    [self.view setUserInteractionEnabled:NO];


    
    [self isLogin1];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createNickName:) name:@"createNickName" object:nil];

    
}
//头像
- (void)headImgAction:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
    sheet.tag=200;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==100) {
        
        if (buttonIndex==0) {
            self.sex.label2.text=@"男";
        }
        else{
            self.sex.label2.text=@"女";
        }
    }
    else {
        if (buttonIndex == 0) {
            [self pickImageFromAlbum];
        }
         if(buttonIndex==1){
            [self pickImageFromCamera];
        }

    }
}

#pragma mark - 选择相册
- (void)pickImageFromAlbum
{
    
    // 从相册中选取
    
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.navigationBar.barTintColor = [UIColor blackColor];
        
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
        
        
    }
    
}

#pragma mark - 选择相机
- (void)pickImageFromCamera
{
    
    
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
        
        
    }
    
    
    
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            
            self.dic = [NSDictionary dictionaryWithDictionary:info];
            self.img=[self.dic objectForKey:@"UIImagePickerControllerOriginalImage"];
        }];
        
        
    }];
}

#pragma mark - 显示信息保存的状态 是否保存成功
- (void)dismissAlert:(UIAlertView *)alert
{
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        if (alert.tag == 110) {
            PersonalViewController *person=[[PersonalViewController alloc]init];
            [self.navigationController pushViewController:person animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    
    
}
//完成剪切图片 上传服务器（代理方法）
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //剪切图片后放到头像上
    
    //设置状态栏高亮
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //点击确定后让剪辑器消失
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        
        //上传图片
        NSString *type = [self.dic objectForKey:UIImagePickerControllerMediaType];
        
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"])
        {
            UIImage *image = [self.dic objectForKey:@"UIImagePickerControllerOriginalImage"];
            [self.headView.headImg setImage:image forState:UIControlStateNormal];
            NSData *data = UIImageJPEGRepresentation(image, 0.01f);
            NSString *imageData = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            self.imageBase64 = imageData;
            
        }
    }];
}
//点击取消按钮，取消剪辑图片（代理方法）
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    //点击取消后让剪辑器消失
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
//uiimagepickerController的代理方法
#pragma mark camera utility
//是否允许访问相册
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility 图片的缩放功能
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - - - - - -  - -  - -  - - -  - - -  - - - - -  - - -

#pragma mark - 获取用户信息

- (void)getCustomerInfo{
    
    [self hideMyPicker];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *userId=[user objectForKey:@"userId"];
    
    [NetworkRequest netWorkRequestPOSTWithString:POST_USER_INFO Parameters:@{@"id" : userId} ResponseBlock:^(id result) {
        NSDictionary *dic=result;
        NSLog(@"%@ dic",dic);
        NSDictionary *dict=[[dic objectForKey:@"msg"]lastObject];
//        [self.headView.headImg setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"headImg"]]] ]forState:UIControlStateNormal];
        [self.headView.headImg setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"headImg"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
        self.birth.label2.text=[dict objectForKey:@"birthDay"];
        self.area.label2.text=[dict objectForKey:@"adress"];
        self.nickName.label2.text=[dict objectForKey:@"nickName"];
        if ([[dict objectForKey:@"sex"] isEqualToString:@"1"]) {
            self.sex.label2.text=@"男";
        } else {
            self.sex.label2.text=@"女";

        }
        self.area.label2.text=[dict objectForKey:@"adress"];
        self.adresId=[dict objectForKey:@"adreId"];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"headImg"]]];
        self.img = [UIImage imageWithData:data];
        
        [LoadIndicator stopAnimationInView:self.view];
        self.view.userInteractionEnabled = YES;
        
        
    } ErrorBlock:^(id error) {
        NSLog(@"faile");
        [LoadIndicator stopAnimationInView:self.view];
        self.view.userInteractionEnabled = YES;


        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接错误" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }];
    

    
}
#pragma mark - 点击事件
- (void)changeAreaAction{
    
    [self hideMyPicker];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"输入地区" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag=100;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)changeNickAciton{
    NickNameViewController *nick=[[NickNameViewController alloc]init];
    [self.navigationController pushViewController:nick animated:YES];
    
}

- (void)createNickName:(NSNotification *)notification{
    
    NSDictionary *thedata=[notification userInfo];
    self.nickName.label2.text=[thedata objectForKey:@"nickName"];

}

- (void)changeBirthAction{
    
    [self.view endEditing:YES];
    
    if (self.myView) {
        [self.myView removeFromSuperview];
        self.myView = nil;
    }
    //获取数据
    [self createMyBirthData];
    //创建pickerView
    [self createDatePicker];
    //创建toolBar
    [self createToolBar:self.regionPicker];
    //显示pickerView
    [self showMyPicker];

}
- (void)changeSexAction{
    UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionsheet.tag=100;
    [actionsheet showInView:self.view];
    
    
}

#pragma mark  -- 完成的点击事件

- (void)finishAction{
    
    [LoadIndicator addIndicatorInView:self.view];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *userId=[user objectForKey:@"userId"];
    
    NSData *data = UIImageJPEGRepresentation(self.img, 0.01f);
    NSString *imageData = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *str;
    if ([self.sex.label2.text isEqualToString:@"男"]) {
        str=@"1";
    } else {
        str=@"0";
    }
    NSLog(@"%@ arae",self.area.label2.text);
    NSString *url=POST_EDIT_USER;
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:str forKey:@"sex"];
    [params setValue:self.area.label2.text forKey:@"address"];
    [params setValue:userId forKey:@"id"];
    [params setValue:self.nickName.label2.text forKey:@"nickName"];
    [params setValue:imageData forKey:@"headImg"];
    [params setValue:self.adresId forKey:@"adreId"];
    [params setValue:self.birth.label2.text forKey:@"birthDay"];
    
    NSLog(@"url===%@",url);
    [NetworkRequest netWorkRequestPOSTWithString:url Parameters:params ResponseBlock:^(id result) {
        NSDictionary *dic=[[result objectForKey:@"msg"] firstObject];
        if ([[dic objectForKey:@"flag"] isEqualToString:@"1"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"编辑成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            alert.tag = 110;
           // [self dismissAlert:alert];
           [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"编辑失败" message:@"请检查信息是否正确" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        }
        
        [LoadIndicator stopAnimationInView:self.view];
        
    } ErrorBlock:^(id error) {
        
        [LoadIndicator stopAnimationInView:self.view];
        NSLog(@"faile");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"编辑失败" message:@"请重试或检查您的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];

    }];
    
    
}



//创建pickerView
- (void)createDatePicker
{
    self.regionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 162)];
    self.regionPicker.delegate = self;
    self.regionPicker.dataSource = self;
    [self.regionPicker setShowsSelectionIndicator:YES];

//    [self.regionPicker setBackgroundColor:[UIColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1]];
    
  
    
}
//添加数据
- (void)createMyBirthData
{
    self.regionArray = [NSMutableArray array];
    NSMutableArray *yearArray = [NSMutableArray array];
    for (int i = 2000; i < 2025; i++) {
        NSString *year = [NSString stringWithFormat:@"%d年", i];
        [yearArray addObject:year];
    }
    
    NSMutableArray *monthArray = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        NSString *month = [NSString stringWithFormat:@"%d月", i];
        [monthArray addObject:month];
    }
    
    NSMutableArray *dayArray = [NSMutableArray array];
    for (int i = 1; i < 32; i++) {
        NSString *day = [NSString stringWithFormat:@"%d日", i];
        [dayArray addObject:day];
    }
    
    [self.regionArray addObject:yearArray];
    [self.regionArray addObject:monthArray];
    [self.regionArray addObject:dayArray];
}
- (void)createToolBar:(UIPickerView *)myPicker
{
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 206)];
    [self.myView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.myView];
    
#warning 修改toolbar 的背景色  加一张白底图片
    //修改背景  需要给出图片
//    UIColor *red =  [ColorList hexStringToColor:@"#ed5d1f"];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    [pickerDateToolbar setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    //
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarCanelClick)];
    [cancelBtn setTintColor:red];
    [barItems addObject:cancelBtn];
    
    
    //
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [flexSpace setTintColor:red];
    [barItems addObject:flexSpace];
    
    
    //
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneClick)];
    [doneBtn setTintColor:red];
    [barItems addObject:doneBtn];
    
    
    [pickerDateToolbar setItems:barItems animated:YES];
    [self.myView addSubview:pickerDateToolbar];
    
    
    
    [self.regionPicker selectRow:15 inComponent:0 animated:YES];
    [self.myView addSubview:myPicker];
    
}
- (void)hideMyPicker
{
    [UIView animateWithDuration:0.2 animations:^{
        self.myView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 206);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showMyPicker
{
    [UIView animateWithDuration:0.2 animations:^{
        self.myView.frame = CGRectMake(0, SCREEN_HEIGHT - 266, SCREEN_WIDTH, 266);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - pickerView的三个方法  和tableview相似
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [[self.regionArray objectAtIndex:component] count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = [self.regionArray objectAtIndex:component];
    
    return [array objectAtIndex:row];

}

#pragma mark - 自定义pickerView每一行的label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //UIColor *red =  [ColorList hexStringToColor:@"#ed5d1f"];
    
    UILabel *mycom1 = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 44)];
    
    NSArray *array = [self.regionArray objectAtIndex:component];
    self.text = [array objectAtIndex:row];
    
    mycom1.text = self.text;
    [mycom1 setFont:[UIFont systemFontOfSize: 17]];
    mycom1.backgroundColor = [UIColor clearColor];
    [mycom1 setTextColor:red];
    [mycom1 setTextAlignment:NSTextAlignmentCenter];
    CFShow((__bridge CFTypeRef)(mycom1));
    
    return mycom1;
    
}
#pragma mark - 选中某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSArray *yearArray = [self.regionArray objectAtIndex:0];
    NSArray *monthArray = [self.regionArray objectAtIndex:1];
    NSArray *dayArray = [self.regionArray objectAtIndex:2];
    
    NSInteger yearRow = [self.regionPicker selectedRowInComponent:0];
    NSInteger monthRow = [self.regionPicker selectedRowInComponent:1];
    NSInteger dayRow = [self.regionPicker selectedRowInComponent:2];
    NSString *year = [[yearArray objectAtIndex:yearRow] stringByReplacingOccurrencesOfString:@"年" withString:@""];
    NSString *month = [[monthArray objectAtIndex:monthRow] stringByReplacingOccurrencesOfString:@"月" withString:@""];
    NSString *day = [[dayArray objectAtIndex:dayRow] stringByReplacingOccurrencesOfString:@"日" withString:@""];
    NSString *myText = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
  //  [self.birth setTitle:myText forState:UIControlStateNormal];
    
    self.birth.label2.text=myText;
}


#pragma mark - tooLbar 的点击事件
- (void)toolBarCanelClick
{
    [self hideMyPicker];
}
- (void)toolBarDoneClick
{
    [self hideMyPicker];
    
}

#pragma mark - alertView 代理

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        switch (buttonIndex) {
            case 0:
            {
                
                self.area.label2.text=[alertView textFieldAtIndex:0].text;
                break;
            }
            default:
                break;
        }

    }
    
    if (alertView.tag==111) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user setObject:@"logout" forKey:@"logout"];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:nil];
        
    }

    
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"createNickName" object:nil];
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
        [self getCustomerInfo];
        
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
        [self finishAction];
        
    } ErrorBlock:^(id error) {
        
        
        
    }];
    
    
}

@end
