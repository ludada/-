//
//  RunnerStoreView.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "RunnerStoreView.h"
#import "GlobalMacro.h"
#import "UIButton+WebCache.h"
#import "CustomItemButton.h"
#import "picModel.h"
#import "RunnerStoreCollectionViewCell.h"
#import "RunnerRecommendCollectionViewCell.h"
@implementation RunnerStoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSMutableArray array];
    }
    return self;
}

- (void)createRunnerStore
{
    [self runnerShop];
}


- (void)setPicArray:(NSMutableArray *)picArray
{
    _picArray = picArray;
    if (picArray.count != 0) {
        [self runnerScroll];
        [self getMyData];
    }
    
}

/**
 *  创建滚动视图
 */
- (void)runnerScroll
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [myView setBackgroundColor:[UIColor whiteColor]];
    if (iPhone4) {
        myView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
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
    
    
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 90, 80, 30)];
    [self.page setNumberOfPages:5];
    [self.page setBackgroundColor:[UIColor clearColor]];
    [self.page setPageIndicatorTintColor:[UIColor whiteColor]];
    [self.page setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    [myView addSubview:self.page];
    

}
/**
 *  获取滚动视图button上的背景图
 */
- (void)getMyData
{
    
    [self.page setNumberOfPages:self.picArray.count];
    [self.scroll setContentSize:CGSizeMake(SCREEN_WIDTH * (self.picArray.count + 1), 0)];
    //添加图片
    for (int i = 0; i <= self.picArray.count; i++) {
        if (i == self.picArray.count) {
            UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scroll.frame.size.height)];
            picModel *model = self.picArray[0];
            [image setImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
            [self.scroll addSubview:image];
            
        }
        else
        {
            picModel *model = self.picArray[i];
            UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scroll.frame.size.height)];
            
            [image setImageWithURL:[NSURL URLWithString:model.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanwei"] options:SDWebImageRetryFailed];
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


//获取金币数据
- (void)setMyCoin:(NSString *)myCoin
{
    _myCoin = myCoin;
    
    [self runnerShop];
    
    [self createCollectionView];


}


/**
 *  创建商品页面
 */
- (void)runnerShop
{
   
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scroll.frame.size.height + self.scroll.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - self.scroll.frame.size.height)];
    [self.downView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.downView];
    
    
    UIImageView *coinImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    [coinImage setImage:[UIImage imageNamed:@"coin"]];
    [coinImage setBackgroundColor:[UIColor clearColor]];
    [self.downView addSubview:coinImage];
    
    self.coin = [[UILabel alloc] initWithFrame:CGRectMake(coinImage.frame.size.width + coinImage.frame.origin.x + 10, 0, 180, 40)];
    [self.coin setBackgroundColor:[UIColor clearColor]];
    NSString *text = [NSString stringWithFormat:@"您的金币: %@ 金币", self.myCoin];
    [self.coin setAttributedText:[GlobalMethod fuwenbenLabel:text FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(5, text.length - 7) AndColor:coinColor]];
    [self.coin setFont:[UIFont systemFontOfSize:15]];
    [self.coin setFont:[UIFont boldSystemFontOfSize:15]];
    [self.downView addSubview:self.coin];
    
    
    
    
    //赚取金币
    self.getCoin = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, self.coin.frame.size.height)];
    [self.getCoin setBackgroundColor:[UIColor clearColor]];
    [self.getCoin setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.getCoin setTitle:@"怎样赚取金币?" forState:UIControlStateNormal];
    self.getCoin.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.getCoin.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    self.getCoin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.downView addSubview:self.getCoin];

    self.how = [[UIButton alloc] initWithFrame:CGRectMake(self.getCoin.frame.origin.x - 18, self.getCoin.frame.origin.y + 12, 15, 15)];
    [self.how setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
//    [image setImage:[UIImage imageNamed:@"help"]];
    [self.downView addSubview:self.how];
    
    //item chose
    self.myView = [[UIButton alloc] initWithFrame:CGRectMake(5, self.coin.frame.size.height + self.coin.frame.origin.y, SCREEN_WIDTH - 10, 30)];
    [_myView setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    _myView.layer.cornerRadius = 7;
    _myView.layer.masksToBounds = YES;
    [self.downView addSubview:_myView];
    
    self.localLife = [[CustomItemButton alloc] initWithFrame:CGRectMake(0, 0, _myView.frame.size.width/2, _myView.frame.size.height) image:[UIImage imageNamed:@"life"] label:@"本地生活"];
    [self.localLife setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    self.localLife.tag = 100;
    [_myView addSubview:self.localLife];
    
    self.shopping = [[CustomItemButton alloc] initWithFrame:CGRectMake(_myView.frame.size.width/2, 0, _myView.frame.size.width/2, _myView.frame.size.height) image:[UIImage imageNamed:@"market"] label:@"精品购物"];
    [self.shopping setTag:110];
    [_myView addSubview:self.shopping];

    
}

/**
 *  创建tableView
 *
 *  @param
 *
 *  @return
 */


- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setItemSize:CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2)];
    [flow setMinimumInteritemSpacing:5];
    [flow setMinimumLineSpacing:5];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flow setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.myView.frame.size.height + self.myView.frame.origin.y, SCREEN_WIDTH, self.downView.frame.size.height - self.myView.frame.origin.y - self.myView.frame.size.height) collectionViewLayout:flow];
    [self.collectView registerClass:[RunnerStoreCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectView registerClass:[RunnerRecommendCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
    [self.collectView setBackgroundColor:[UIColor clearColor]];
    [self.downView addSubview:self.collectView];
    
}





////设置不同字体颜色
//-(NSMutableAttributedString *)fuwenbenLabel:(NSString *)string FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
//{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
//    
//    //设置字号
//    [str addAttribute:NSFontAttributeName value:font range:range];
//    
//    //设置文字颜色
//    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
//    
//    return str;
//}





@end