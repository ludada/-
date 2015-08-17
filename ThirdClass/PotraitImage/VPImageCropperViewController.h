//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPImageCropperViewController;
//引用自身？？？因为代理要用
@protocol VPImageCropperDelegate <NSObject>
//编辑结束（点击确定吗？？）（裁剪结束）
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
//点击取消(裁剪取消)
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;

@end

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
//设置代理
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
