//
//  AppDelegate.h
//  Community Cloud
//
//  Created by Mo's tec on 14-10-14.
//  Copyright (c) 2014年 Mo's tec. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest ()

@end

@implementation NetworkRequest
static NetworkRequest *instance;


+(NetworkRequest *)shareNetWorkRequest{
    @synchronized(self){
        if(nil == instance){
            instance = [[NetworkRequest alloc] init];
        }
    }
    return instance;
}

// GET请求
+ (void)netWorkRequestGetWithString:(NSString *)string ResponseBlock:(ResponseBlock)block{
    NetworkRequest * request = [[NetworkRequest alloc] init];
    [request netWorkRequestGetWithString:string ResponseBlock:^(id data) {
        block(data);
    }];
}

- (void)netWorkRequestGetWithString:(NSString *)string ResponseBlock:(ResponseBlock)block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


// GET请求带网络错误检测
+ (void)netWorkRequestGetWithString:(NSString *)string ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock{
    NetworkRequest * request = [[NetworkRequest alloc] init];
    [request netWorkRequestGetWithString:string ResponseBlock:^(id data) {
        block(data);
    } ErrorBlock:^(id data) {
        errorBlock(data);
    }];
}

- (void)netWorkRequestGetWithString:(NSString *)string ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response = %@", operation.response.description);
        block(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
    }];
}



// POST请求
+ (void)netWorkRequestPOSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block{
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request netWorkRequestPOSTWithString:string Parameters:parameters ResponseBlock:^(id data) {
        block(data);
    }];
}

- (void)netWorkRequestPOSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:string parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



// POST请求带网络错误检测
+ (void)netWorkRequestPOSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock{
    NetworkRequest *request = [[NetworkRequest alloc] init];
    NSLog(@"request = %@", request.description);
    [request netWorkRequestPOSTWithString:string Parameters:parameters ResponseBlock:block ErrorBlock:errorBlock];
}

- (void)netWorkRequestPOSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:string parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
        NSLog(@"Error: %@", error);
    }];
}


// POST请求带网络错误检测
+ (void)netWorkRequest1POSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock{
    NetworkRequest *request = [[NetworkRequest alloc] init];
    NSLog(@"request = %@", request.description);
    [request netWorkRequest1POSTWithString:string Parameters:parameters ResponseBlock:block ErrorBlock:errorBlock];
}

- (void)netWorkRequest1POSTWithString:(NSString *)string Parameters:(NSDictionary *)parameters ResponseBlock:(ResponseBlock)block ErrorBlock:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:string parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
        NSLog(@"Error: %@", error);
    }];
}



// 文件下载
+ (void)netWorkDownloadWithString:(NSString *)string FilePath:(NSString *)filePath ResponseBlock:(ResponseBlock)block{
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request netWorkDownloadWithString:string FilePath:filePath ResponseBlock:^(id data) {
        block(data);
    }];
}

- (void)netWorkDownloadWithString:(NSString *)string FilePath:(NSString *)filePath ResponseBlock:(ResponseBlock)block{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
        NSLog(@"error == %@",error);
        block(filePath);
    }];
    [downloadTask resume];
}




// 文件上传
+ (void)netWorkUploadWithString:(NSString *)string FilePath:(NSString *)filePath ResponseBlock:(ResponseBlock)block{
    NetworkRequest *request = [[NetworkRequest alloc] init];
    [request netWorkUploadWithString:string FilePath:filePath ResponseBlock:^(id data) {
        block(data);
    }];
}

- (void)netWorkUploadWithString:(NSString *)string FilePath:(NSString *)filePath ResponseBlock:(ResponseBlock)block{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePathURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

@end