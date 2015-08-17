//
//  GoodsDetailView.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-12.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "GoodsDetailView.h"
#import "GlobalMacro.h"
#import "GlobalMethod.h"
#import "picModel.h"
#import "UIButton+WebCache.h"
#import "GoodsDetailModel.h"
@implementation GoodsDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSMutableArray array];
    }
    return self;
}

//获取数据源
- (void)setModel:(GoodsDetailModel *)model
{
    _model = model;
    [self createGoodsDetailView];
}

- (void)createGoodsDetailView
{
    [self createGoodsScrollView];
    [self createDetailView];
}

/**
 *  创建滚动视图
 */
- (void)createGoodsScrollView
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    [myView setBackgroundColor:[UIColor whiteColor]];
    if (iPhone4) {
        myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    }
    [self addSubview:myView];
    
    //滚动视图
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, myView.frame.size.height)];
    [self.scroll setBackgroundColor:[UIColor clearColor]];
    [self.scroll setContentSize:CGSizeMake(SCREEN_WIDTH * 5, 0)];
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    self.scroll.showsHorizontalScrollIndicator = NO;
    [myView addSubview:self.scroll];
    
    
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 160, 80, 30)];
    [self.page setNumberOfPages:5];
    [self.page setBackgroundColor:[UIColor clearColor]];
    [self.page setPageIndicatorTintColor:[UIColor whiteColor]];
    [self.page setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    [myView addSubview:self.page];
    
    [self getMyData];
    
}
/**
 *  获取滚动视图button上的背景图
 */
- (void)getMyData
{
    self.picArray = (NSMutableArray *)[GlobalMethod getPicArrayFromString:self.model.minImg];
    [self.page setNumberOfPages:self.picArray.count];
    [self.scroll setContentSize:CGSizeMake(SCREEN_WIDTH * (self.picArray.count + 1), self.scroll.frame.size.height)];
    //添加图片
    for (int i = 0; i <= self.picArray.count; i++) {
        if (i == self.picArray.count) {
            UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scroll.frame.size.height)];
            [image setImageWithURL:[NSURL URLWithString:self.picArray[0]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
            [self.scroll addSubview:image];
            
        }
        else
        {
            UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scroll.frame.size.height)];
            
            [image setImageWithURL:[NSURL URLWithString:self.picArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
            [self.scroll addSubview:image];
        }
    }
    
    
}

//设置定时器
- (void)setTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(toScroll) userInfo:nil repeats:YES];
}
//移除定时器
- (void)removeTimer
{
    [self.timer invalidate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖拽的时候 移除计时器
    [self removeTimer];
}

- (void)toScroll
{
    NSInteger page = self.page.currentPage;
    if (page == self.picArray.count - 1) {
        page = self.picArray.count;
    }
    else
    {
        page ++;
    }
    CGFloat x = page * SCREEN_WIDTH;
    [self.scroll setContentOffset:CGPointMake(x, 0) animated:YES];//滑到下一个,直到添加的那个
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.page.currentPage = (CGFloat)(self.scroll.contentOffset.x + SCREEN_WIDTH/2)/SCREEN_WIDTH;
    if (self.page.currentPage > (self.picArray.count - 1)) {
        self.page.currentPage = 0;
    }
    if (self.scroll.contentOffset.x >= SCREEN_WIDTH * self.picArray.count) {
        [self.scroll setContentOffset:CGPointMake(0, 0)];//还原到第一个
    }
}

/**
 *  创建金币, 商品详情界面
 */
- (void)createDetailView
{
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scroll.frame.size.height + self.scroll.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - self.scroll.frame.size.height)];
    [self.downView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.downView];
    
    
    UIImageView *coinImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    [coinImage setImage:[UIImage imageNamed:@"coin"]];
    [coinImage setBackgroundColor:[UIColor clearColor]];
    [self.downView addSubview:coinImage];
    
    self.coin = [[UILabel alloc] initWithFrame:CGRectMake(coinImage.frame.size.width + coinImage.frame.origin.x + 15, 7, 180, 40)];
    [self.coin setBackgroundColor:[UIColor clearColor]];
    [self.coin setTextColor:coinColor];
    [self.coin setText:[NSString stringWithFormat:@"%@", self.model.points]];
    [self.coin setFont:[UIFont systemFontOfSize:15]];
    [self.coin setFont:[UIFont boldSystemFontOfSize:15]];
    [self.downView addSubview:self.coin];
    
    
    self.purchase = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 80, 30)];
    [self.purchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.purchase setTitle:@"购买" forState:UIControlStateNormal];
    [self.purchase.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.purchase.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.purchase setBackgroundColor:[UIColor orangeColor]];
    self.purchase.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    self.purchase.layer.masksToBounds = YES;
    self.purchase.layer.cornerRadius = 5;
    [self.downView addSubview:self.purchase];
    
    
    [GlobalMethod drawLineWithFrame:CGRectMake(0, self.purchase.frame.origin.y + self.purchase.frame.size.height + 10, SCREEN_WIDTH, 0.5) inView:self.downView];
    UILabel *introduce = [[UILabel alloc] initWithFrame:CGRectMake(10, self.purchase.frame.size.height + self.purchase.frame.origin.y + 20, 100, 20)];
    [introduce setFont:[UIFont systemFontOfSize:15]];
    [introduce setFont:[UIFont boldSystemFontOfSize:15]];
    [introduce setText:@"商品简介"];
    [self.downView addSubview:introduce];
    
    
    CGFloat height = [GlobalMethod GetMyTextHeight:self.model.desc font:15 width:SCREEN_WIDTH - 20];
    if (height > 250) {
        height = 250;
    }
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(introduce.frame.origin.x, introduce.frame.size.height + introduce.frame.origin.y + 20, SCREEN_WIDTH  -20, height)];
    
    self.content.numberOfLines = 0;
    [self.content setText:self.model.desc];
    [self.content setFont:[UIFont systemFontOfSize:13]];
    [self.downView addSubview:self.content];
    
    
    
    
}




@end
