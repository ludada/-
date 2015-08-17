//
//  InputTableViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15-4-29.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "InputTableViewCell.h"

@implementation InputTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width/10, self.frame.size.width/10)];
        [self.headImg setBackgroundColor:[UIColor whiteColor]];
//        self.content=[[UIButton alloc]init];
//        
        //[self setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:self.headImg];
        
//        [self addSubview:self.content];
        
        self.label1=[[UILabel alloc]init]
        ;
        [self.label1 setBackgroundColor:[UIColor whiteColor]
        ];
        self.label1.font=[UIFont systemFontOfSize:20];
        self.label1.numberOfLines=0;
        [self addSubview:self.label1];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    CGSize s = [@"ww" sizeWithFont:[UIFont systemFontOfSize:20]];
    CGFloat height=s.height;

    self.headImg.frame=CGRectMake(10, 10, self.frame.size.width/10 , self.frame.size.width/10);
    
    self.label1.frame=CGRectMake(self.frame.size.width/10+20, 10, self.frame.size.width*2/3, self.frame.size.height-10);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
