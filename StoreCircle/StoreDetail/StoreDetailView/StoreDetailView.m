//
//  StoreDetailView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "StoreDetailView.h"
#import "GlobalMacro.h"
#import "CustomSDetailView.h"
#import "GlobalMethod.h"
#import "GlobalMethod.h"
#import "StoreDetailModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SJAvatarBrowser.h"
@implementation StoreDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSMutableArray array];
        self.scrollArray = [NSMutableArray array];
        
        self.upPicArray = [NSMutableArray array];
        self.downPicArray = [NSMutableArray array];
    }
    return self;
}

- (void)createDetailView
{
    [self detailHeaderView];
    [self detailInfo];
}

//set方法获取数据
- (void)setDataModel:(StoreDetailModel *)dataModel
{
    _dataModel = dataModel;
    [self createDetailView];
}

- (void)detailHeaderView
{
    self.scrollUp = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    self.scrollUp.delegate = self;
    self.scrollUp.pagingEnabled = YES;
    self.scrollUp.contentSize  =CGSizeMake(SCREEN_WIDTH, 190);
    [self.scrollUp setBackgroundColor:[UIColor clearColor]];
    self.scrollUp.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollUp];
    
#warning 到底是一张还是多张图片?
    NSArray *picArray = [self mydownPicArray:self.dataModel.signaImg];
    //给图片和label赋值
    for (int i = 0; i < picArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.scrollUp.frame.size.height)];
        [button setImageWithURL:[NSURL URLWithString:picArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
        button.tag = 100+ i;
//        [button setBackgroundColor:[UIColor grayColor]];
        [self.upPicArray addObject:button];
        [self.scrollUp addSubview:button];
        
        UIButton *accessoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.scrollUp.frame.size.height - 40, SCREEN_WIDTH, 40)];
        [accessoryBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        [accessoryBtn setTitle:self.dataModel.storName forState:UIControlStateNormal];
//        [accessoryBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [accessoryBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        UIFont *font = [UIFont systemFontOfSize:17];
        [accessoryBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        CGSize size = [self.dataModel.storName  sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil]];
        [accessoryBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, SCREEN_WIDTH - 20 - size.width)];
        [accessoryBtn setTag:10 + i];
        [button addSubview:accessoryBtn];
        
    }
    
    
}

- (void)detailInfo
{
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0 , self.scrollUp.frame.size.height + self.scrollUp.frame.origin.y , SCREEN_WIDTH, SCREEN_HEIGHT - self.scrollUp.frame.size.height - 64)];
    [self addSubview:downView];
    
    UILabel *introduct = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    [introduct setText:@"店铺简介"];
    [introduct setFont:[UIFont systemFontOfSize:15]];
    [introduct setFont:[UIFont boldSystemFontOfSize:15]];
    [introduct setTextAlignment:NSTextAlignmentLeft];
    [downView addSubview:introduct];
    
    //自适应高度
    self.introduce = [[UILabel alloc] initWithFrame:CGRectMake(introduct.frame.origin.x, introduct.frame.origin.y + introduct.frame.size.height + 10, SCREEN_WIDTH - 20, 140)];
    [self.introduce setFont:[UIFont systemFontOfSize:13]];
    [self.introduce setNumberOfLines:0];
    [self.introduce setText:self.dataModel.storDesc];
    [downView addSubview:self.introduce];
    
    //获取自动高度
     CGRect myRect = [self.dataModel.storDesc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 10000) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName,nil] context:nil];
    
    self.introduce.frame = CGRectMake(introduct.frame.origin.x, introduct.frame.origin.y + introduct.frame.size.height + 10, SCREEN_WIDTH - 20, myRect.size.height + 10);
    
    if (iPhone5) {
        
        if (myRect.size.height > 120) {
            
            self.introduce.frame = CGRectMake(introduct.frame.origin.x, introduct.frame.origin.y + introduct.frame.size.height + 10, SCREEN_WIDTH - 20, 130);
            
        }
    }
    
    
    

    
    self.address = [[CustomSDetailView alloc] initWithFrame:CGRectMake(10, 10 + self.introduce.frame.origin.y + self.introduce.frame.size.height, SCREEN_WIDTH - 20, 40) title:@"地址" content:self.dataModel.address image:[UIImage imageNamed:@"load"]];
    [downView addSubview:self.address];
    
    [GlobalMethod drawLineWithFrame:CGRectMake(0, 0, self.address.frame.size.width, 0.5) inView:self.address];
    [GlobalMethod drawLineWithFrame:CGRectMake(0, 39.5, self.address.frame.size.width, 0.5) inView:self.address];
    
    self.tele = [[CustomSDetailView alloc] initWithFrame:CGRectMake(self.address.frame.origin.x, self.address.frame.origin.y + self.address.frame.size.height, self.address.frame.size.width, self.address.frame.size.height) title:@"电话" content:self.dataModel.phone image:[UIImage imageNamed:@"phone"]];
    [downView addSubview:self.tele];
    
    [GlobalMethod drawLineWithFrame:CGRectMake(0, 39.5, self.address.frame.size.width, 0.5) inView:self.tele];
    
    UILabel *picDetail = [[UILabel alloc] initWithFrame:CGRectMake(10 , self.tele.frame.origin.y + self.tele.frame.size.height, 100, 20)];
    [picDetail setFont:[UIFont systemFontOfSize:15]];
    [picDetail setFont:[UIFont boldSystemFontOfSize:15]];
//    [picDetail setBackgroundColor:[UIColor orangeColor]];
    [picDetail setText:@"图片详情"];
    [downView addSubview:picDetail];
    
    self.scrollDown = [[UIScrollView alloc] initWithFrame:CGRectMake(10, picDetail.frame.origin.y + picDetail.frame.size.height + 10, self.address.frame.size.width, (self.address.frame.size.width - 15)/4)];
    [self.scrollDown setContentSize:CGSizeMake(((self.address.frame.size.width - 15)/4 + 5) * 4 - 10, (self.address.frame.size.width - 15)/4)];
    [self.scrollDown setBackgroundColor:[UIColor whiteColor]];
    [self.scrollDown setPagingEnabled:YES];
    [self.scrollDown setDelegate:self];
    [downView addSubview:self.scrollDown];
    
    
    if (self.scrollDown.frame.origin.y > (downView.frame.size.height - self.scrollDown.frame.size.height)) {
        
        self.scrollDown.frame = CGRectMake(10, (downView.frame.size.height - self.scrollDown.frame.size.height), self.address.frame.size.width, (self.address.frame.size.width - 15)/4);
        
    }
    
    
    NSArray *array = [self mydownPicArray:self.dataModel.minImg];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ((self.address.frame.size.width - 15)/4 + 5), 0, (self.address.frame.size.width - 15)/4, (self.address.frame.size.width - 15)/4)];
        [button setTag:i + 1000];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setImageWithURL:[NSURL URLWithString:array[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
        [button addTarget:self action:@selector(imageViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.downPicArray addObject:button];
        [self.scrollDown addSubview:button];
        
    }
    
    
}



#pragma mark - 逗号分割图片  获取底部图片数组
- (NSArray *)mydownPicArray:(NSString *)picString
{
    if ([picString rangeOfString:@","].location != NSNotFound ) {
        NSArray *array = [picString componentsSeparatedByString:@","];
        return array;
    }
    else
    {
        if (picString != nil) {
            NSArray *array = @[picString];
            return array;
        }
        return nil;
    }
    
}


- (void)imageViewAction:(UIButton *)button{
    
    [SJAvatarBrowser showImage:button];
    
    
}


@end
