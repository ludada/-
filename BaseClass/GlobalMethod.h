//
//  GlobalMethod.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalMethod : NSObject

// 须指明在哪一个UIView中画线  (这个是两点间画线)
+ (void)drawLineWithStartPoint:(CGPoint)startPoint
                      EndPoint:(CGPoint)endPoint
                      inUIView:(UIView *)view;


// 根据tag值可以操作这条线（删除）
+ (void)drawLineWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint inUIView:(UIView *)view myTag:(NSInteger)myTag;


/***********************************/


//通过在view上的frame画图  即在view上添加一个view
+ (void)drawLineWithFrame:(CGRect)frame inView:(UIView *)view;


//自定义线的颜色
+ (void)drawLineWithFrame:(CGRect)frame inView:(UIView *)view withColor:(UIColor *)color;


//颜色RGB转换
+(UIColor *)hexStringToColor: (NSString *) stringToConvert;


/**
 *  MD5加密
 *
 *  @param str
 *
 *  @return
 */
+(NSString *)md5:(NSString *)str;


//解析后获取字典
+ (NSDictionary *)dictionaryResults:(id)result;

//解析后获取数组
+ (NSMutableArray *)arrayResults:(id)result;

//获取图片
+ (NSArray *)getPicArrayFromString:(NSString *)picture;

//获取UserId
+ (NSString *)UserId;

//获取参数字典
+ (NSDictionary *)paramatersForValues:(NSArray *)values keys:(NSString *)keys;


//获取label的自适应高度
+ (CGFloat)GetMyTextHeight:(NSString *)text font:(CGFloat)font width:(CGFloat)width;

//获取文字高度和长度
+ (CGSize)sizeOfText:(NSString *)text font:(CGFloat)font;


//设置不同字体颜色(一段文本内字体的不同颜色)
+ (NSMutableAttributedString *)fuwenbenLabel:(NSString *)string FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;



@end
