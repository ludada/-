//
//  KCAnnotation.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface KCAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate2D;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;
@end
