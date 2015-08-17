//
//  Notification1TableViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15/5/28.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "Notification1TableViewCell.h"
#import "UIView+Frame.h"




@implementation Notification1TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.time=[[UILabel alloc]init];
        self.time.font=[UIFont systemFontOfSize:13];
        [self.time setTextColor:[UIColor grayColor]];
        self.time.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:self.time];
        
        
        self.content=[[UILabel alloc]init];
        self.content.font=[UIFont systemFontOfSize:13];
        self.content.textAlignment=NSTextAlignmentLeft;
        [self.content setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.content];
        
        
        
    }
    return self;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.time.frame=CGRectMake(10, 2, self.width/2, self.height/3-4);
    self.content.frame=CGRectMake(10, self.height/3+2, self.width-4, self.height*2/3-4);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
