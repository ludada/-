//
//  BaseModel.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#if NS_BLOCKS_AVAILABLE
typedef void(^configBlock)(NSString *property);
#endif

/**
 *  model基类(所有的model类都要继承这个类)
 */
@interface BaseModel : NSObject<NSCoding>

/**
 *  通过字典初始化本类，item的key要和本类的属性保持一致
 *
 *  @param item
 *
 *  @return
 */

- (id)initWithDictionary:(NSDictionary *)item;

/**
 *  转成字典类型
 *
 *  @return 字典
 */

- (NSMutableDictionary *)toDictionary;


- (void)configDataValue:(configBlock)block;



@end
