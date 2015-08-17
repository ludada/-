//
//  CashTicketsTableViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-30.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "CashTicketsTableViewCell.h"
#import "GlobalMacro.h"
@implementation CashTicketsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:BackGray];
        self.backImg=[[UIImageView alloc]init];
        [self addSubview:self.backImg];
        
        self.moneyCount=[[UILabel alloc]init];
        [self addSubview:self.moneyCount];
        
        self.tickesId=[[UILabel alloc]init];
        [self addSubview:self.tickesId];
        
        self.deadLine=[[UILabel alloc]init];
        [self addSubview:self.deadLine];
         self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backImg.frame=CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20);
    //self.backImg.image=[UIImage imageNamed:@"daijinquan_03"]
    self.moneyCount.frame=CGRectMake(self.frame.size.width*5/12, self.frame.size.height/12, self.frame.size.width/2, self.frame.size.height/3);
    [self.moneyCount setTextColor:[UIColor whiteColor]];
    self.moneyCount.font=[UIFont systemFontOfSize:30];
    
    self.tickesId.frame=CGRectMake(20, self.frame.size.height*3/5, self.frame.size.width/2, self.frame.size.height/15);
    self.tickesId.font=[UIFont systemFontOfSize:12];
    [self.tickesId setTextColor:[UIColor grayColor]];
    
    self.deadLine.frame=CGRectMake(20, self.frame.size.height*3/5+self.frame.size.height/15+10, self.frame.size.width/2, self.frame.size.height/15);
    self.deadLine.font=[UIFont systemFontOfSize:12];
    [self.deadLine setTextColor:[UIColor grayColor]];

    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
