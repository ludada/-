//
//  Notification2TableViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15/5/28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "Notification2TableViewCell.h"
#import "UIView+Frame.h"

@implementation Notification2TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.time=[[UILabel alloc]init];
        self.time.font=[UIFont systemFontOfSize:13];
        [self.time setTextColor:[UIColor grayColor]];
        self.time.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.time];
        
        self.content=[[UILabel alloc]init];
        self.content.font=[UIFont systemFontOfSize:15];
        [self.content setTextColor:[UIColor grayColor]];
        self.content.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.content];
        
        self.button=[[UIButton alloc]init];
        [self.button.layer setCornerRadius:10];
        self.button.layer.masksToBounds=YES;
        self.button.titleLabel.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.button];
    }
    return self;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.time.frame=CGRectMake(10, 2,self.width/3 , self.height/3-4);
    self.content.frame=CGRectMake(10, self.time.frame.origin.y + self.time.frame.size.height + 10, self.width*3/5-4, 20);
    self.button.frame=CGRectMake(self.width*3/5+13, self.height/3-3, self.width*2/5-26, 35);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
