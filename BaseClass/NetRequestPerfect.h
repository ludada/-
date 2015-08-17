//
//  NetRequestPerfect.h
//  NetWorkingRequest
//
//  Created by HLKJ on 15/7/21.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DYYRequestLoadingStyle) {
    
    DYYRequestLoadingStyleNone,
    DYYRequestLoadingStyleIsHub,
    DYYRequestLoadingStyleIsIndicator,
    DYYRequestLoadingStyleIsHubWithErrorAlert,
    DYYRequestLoadingStyleIsIndicatorWithErrorAlert,

};



typedef void(^ResponseBlock)(id result);
typedef void(^ErrorBlock)(id error);


@interface NetRequestPerfect : NSObject



//post请求
+ (void)NetworkRequestPerfect_POST_WithUrl:(NSString *)url
                                     param:(NSDictionary *)param
                              loadingStyle:(DYYRequestLoadingStyle)style
                                    inView:(UIView *)view
                                   success:(ResponseBlock)successBlocks
                                     error:(ErrorBlock)errorBlocks;



//get请求
+ (void)NetworkRequestPerfect_GET_WithUrl:(NSString *)url
                             loadingStyle:(DYYRequestLoadingStyle)style
                                   inView:(UIView *)view
                                  success:(ResponseBlock)successBlocks
                                    error:(ErrorBlock)errorBlocks;








@end
