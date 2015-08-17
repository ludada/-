//
//  AppDelegate.h
//  Community Cloud
//
//  Created by Mo's tec on 14-10-14.
//  Copyright (c) 2014年 Mo's tec. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef void(^ResponseBlock)(id result);
typedef void(^ErrorBlock)(id error);

@interface NetworkRequest : NSObject<NSURLConnectionDataDelegate>

+(NetworkRequest *)shareNetWorkRequest;
// GET请求
+ (void)netWorkRequestGetWithString:(NSString *)string ResponseBlock:(ResponseBlock)block;

// POST请求
+ (void)netWorkRequestPOSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block;

// POST请求带网络错误检测
+ (void)netWorkRequestPOSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock;

// GET请求带网络错误检测
+ (void)netWorkRequestGetWithString:(NSString *)string ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock;

// 文件下载
+ (void)netWorkDownloadWithString:(NSString *)string FilePath:(NSString *)filePath ResponseBlock:(ResponseBlock)block;

// 文件上传
+ (void)netWorkUploadWithString:(NSString *)string FilePath:(NSString *)filePath ResponseBlock:(ResponseBlock)block;


@end