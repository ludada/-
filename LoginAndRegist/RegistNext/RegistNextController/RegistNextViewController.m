//
//  RegistNextViewController.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RegistNextViewController.h"
#import "RegistNextView.h"
#import "GlobalMacro.h"
#import "URLMacro.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetworkRequest.h"
#import "GlobalMethod.h"
#import "CustomLoginView.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "Singleton.h"
#import "APService.h"
#import "ProvinceViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@interface RegistNextViewController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, VPImageCropperDelegate,UIActionSheetDelegate, UITextFieldDelegate>

@end

@implementation RegistNextViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.backButton = YES;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    self.next = [[RegistNextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.next createRegistNextView];
    [self.view addSubview:self.next];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self.next.headImg addTarget:self action:@selector(headImgAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.next.go addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.next.segControl addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    [self.next.regionButton addTarget:self action:@selector(regionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.next.nickName.field.delegate = self;
    self.next.nickName.field.tag = 100;
    self.next.address.field.delegate = self;
    self.next.address.field.tag = 101;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressAction:) name:@"ADDRESS" object:nil];
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADDRESS" object:nil];
    
}


/**
 *  获取头像图片
 */

//头像
//头像点击事件
- (void)headImgAction:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
    [sheet showInView:self.view];
}

//选择相册 或 相机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self pickImageFromAlbum];
    }
    if (buttonIndex == 1) {
        [self pickImageFromCamera];
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
            
        }];
        
        
    }];
}

#pragma mark - 显示信息保存的状态 是否保存成功
- (void)dismissAlert:(UIAlertView *)alert
{
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        
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
            [self.next.headImg setImage:image forState:UIControlStateNormal];
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



/**
 *  上传数据到服务器
 */
- (void)transferDataToServer
{
    [self showHudInView:self.view hint:@"正在注册.."];

    NSString *sex = [self.next.segControl titleForSegmentAtIndex:self.next.segControl.selectedSegmentIndex];
    if ([sex isEqualToString:@"男"]) {
        sex = @"1";
    }
    else
    {
        sex = @"0";
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"type"];
    [dic setValue:self.myTel forKey:@"mobileNo"];
    NSString *passmd = [GlobalMethod md5:self.password];
    [dic setValue:passmd forKey:@"password"];
    [dic setValue:self.imageBase64 forKey:@"headImg"];
    [dic setValue:self.next.nickName.field.text forKey:@"nickName"];
    [dic setValue:sex forKey:@"sex"];
    [dic setValue:self.next.address.field.text forKey:@"address"];
    [dic setValue:self.provinceId forKey:@"provId"];
    [dic setValue:self.cityId forKey:@"cityId"];
    [dic setValue:self.areaId forKey:@"distId"];
    
    if ([self.imageBase64 isEqualToString:@""] || self.imageBase64 == nil || [self.next.address.field.text isEqualToString:@""] || self.next.address.field.text == nil || self.next.nickName.field.text == nil || [self.next.nickName.field.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息填写不完整" message:@"请检查后提交" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        [self hideHud];  
        
        return;
        
    }
    
    
   [NetworkRequest netWorkRequestPOSTWithString:POST_LOGIN_REGIST_FORGET Parameters:dic ResponseBlock:^(id result) {
       NSLog(@"%@", result);
       NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
       NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
       NSString *userId=[dic objectForKey:@"id"];
       [user setObject:userId forKey:@"userId"];
       [user removeObjectForKey:@"logout"];
       [self notice:result];
   } ErrorBlock:^(id error) {
       NSLog(@"%@", error);
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
       [alert show];
       [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5f];
       [self hideHud];
   }];
}


//调用登录接口
- (void)Login
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:self.myTel forKey:@"mobileNo"];
    NSString *pass = [GlobalMethod md5:self.password];
    [para setValue:pass forKey:@"password"];
    [para setValue:@"2" forKey:@"type"];
    [para setValue:@"0" forKey:@"nickName"];
    [para setValue:@"0" forKey:@"sex"];
    [para setValue:@"0" forKey:@"address"];
    [para setValue:@"0" forKey:@"headImg"];
    [NetworkRequest netWorkRequestPOSTWithString:POST_LOGIN_REGIST_FORGET Parameters:para ResponseBlock:^(id result) {
        NSLog(@"%@", result);
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:self.myTel forKey:@"mobileNo"];
        NSDictionary *dic=[[result objectForKey:@"msg"]firstObject];
        NSString *head=[dic objectForKey:@"headImg"];
        [user setObject:head forKey:@"headImg"];
        [self noticeLogin:result];
    } ErrorBlock:^(id error) {
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败, 请重新登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
        [self hideHud];
    }];

}


/**
 *  根据result显示结果
 *
 *  @param result
 */
- (void)noticeLogin:(id)result
{
    NSDictionary * dic = (NSDictionary *)result;
    NSArray *dataArray = [dic objectForKey:@"msg"];
    NSDictionary *myDic = [dataArray firstObject];
    if ([[myDic objectForKey:@"mobileNo"] isEqualToString:@"1"] && [[myDic objectForKey:@"password"] isEqualToString:@"1"]) {
        //保存用户id
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:[myDic objectForKey:@"id"] forKey:@"userId"];
        
        if ([[myDic objectForKey:@"online"] isEqualToString:@"0"]) {
            
            Singleton *share = [Singleton shareInstance];
            
            //创建标签试图控制器
            UITabBarController *tab = [[UITabBarController alloc] init];
            //字
            tab.tabBar.tintColor = Green;
            //tab
            tab.tabBar.barTintColor = TabGray;
            
            tab.viewControllers = share.myTabArray;
            [self hideHud];
            [self presentViewController:tab animated:YES completion:nil];
            [user setValue:[myDic objectForKey:@"tagId"] forKey:@"tagId"];
            
            
            [APService setTags:[NSSet setWithObjects:[myDic objectForKey:@"tagId"], nil] alias:nil callbackSelector:nil object:nil];


            share.redBall = YES;
            
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"已有账号登陆,是否强制登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag=99;
            [alert show];
            
        }
        
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self hideHud];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
    }
    
}


/**
 *  进入快跑
 */

- (void)goAction:(id)sender
{
    [self.view endEditing:YES];
    [self transferDataToServer];
}

- (void)notice:(id)result
{
    BOOL nick = [self judgeNumber:self.next.nickName.field.text noti:@"用户名格式不正确"];
    if (nick == YES) {
        NSDictionary * dic = (NSDictionary *)result;
        NSLog(@"%@", result);
        NSArray *dataArray = [dic objectForKey:@"msg"];
        NSDictionary *myDic = [dataArray firstObject];
        if ([[myDic objectForKey:@"mobileNo"] isEqualToString:@"1"] && [[myDic objectForKey:@"password"] isEqualToString:@"1"]) {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:self.myTel forKey:@"mobileNo"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"请到系统消息领取优惠券" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
           // [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            
            
            //保存用户id
        //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:[myDic objectForKey:@"id"] forKey:@"userId"];
            
            
            [user setValue:@"1" forKey:@"registFirst"];
            
            //注册成功后调用登录
            [self Login];

            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            [self hideHud];

        }

    }
    
}



- (BOOL)judgeNumber:(NSString *)text noti:(NSString *)title
{
    NSArray *stringArr = [NSArray arrayWithObjects:@"@",@"#",@"$", @"%", @"^", @"&", @"*", @"(",@")",@"-", @"+",@"=",@"{",@"[",@"]",@"]", @"!",@"~",nil];
    for (int i = 0; i < stringArr.count;i++) {
        if ([text rangeOfString:stringArr[i]].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.5];
            [self hideHud];
            return NO;
        }
    }
    
    return YES;
    
}



/**
 *  mb 登录进程加载
 *
 *  @param HUD
 */

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  显示
 *
 *  @param view
 *  @param hint  (加载显示的内容)
 */
- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

/**
 *  停止hud
 */
- (void)hideHud{
    [[self HUD] hide:YES];
}


/**
 *  选择男女
 *
 *  @param sender
 */
- (void)segAction:(id)sender
{
    if (self.next.segControl.selectedSegmentIndex == 0)
    {
        [self.next.segControl setTintColor:Blue];
    }
    else
    {
        [self.next.segControl setTintColor:red];
    }
}



#pragma mark - 输入时键盘弹出
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {

        if (iPhone5 || iPhone6 ) {
            [UIView animateWithDuration:0.3 animations:^{
                self.next.frame = CGRectMake(0, - 100, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.nickName = YES;
                self.address = NO;
            }];

        }
        
        if (iPhone4) {
            [UIView animateWithDuration:0.3 animations:^{
                self.next.frame = CGRectMake(0, - 150, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.nickName = YES;
                self.address = NO;
            }];

        }
        
        
        
    }
    
    if (textField.tag == 101) {

        if (iPhone5 || iPhone6) {
            [UIView animateWithDuration:0.3 animations:^{
                self.next.frame = CGRectMake(0, - 120, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.nickName = NO;
                self.address = YES;
            }];
        }
        
        if (iPhone4) {
            [UIView animateWithDuration:0.3 animations:^{
                self.next.frame = CGRectMake(0, - 180, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                self.nickName = NO;
                self.address = YES;
            }];
        }
        
       
        
    }
    
}

- (void)regionButtonAction:(id)sender
{
    ProvinceViewController *province = [[ProvinceViewController alloc] init];
    [self.navigationController pushViewController:province animated:YES];
    
}

//编辑结束, 键盘回收代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.next.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.nickName = NO;
        self.address = NO;
    }];
}


- (void)addressAction:(NSNotification *)noti
{
    
    NSLog(@"%@", noti.userInfo);
    
    NSString *address = [NSString stringWithFormat:@"%@,%@,%@", [noti.userInfo objectForKey:@"provinceName"], [noti.userInfo objectForKey:@"cityName"], [noti.userInfo objectForKey:@"areaName"]];
    
    [self.next.regionButton setTitle:address forState:UIControlStateNormal];
    
    self.provinceId = [noti.userInfo objectForKey:@"provinceId"];
    
    self.cityId = [noti.userInfo objectForKey:@"cityId"];
    
    self.areaId = [noti.userInfo objectForKey:@"areaId"];
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
