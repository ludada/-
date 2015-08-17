//
//  OrderListTableViewCell.m
//  FasterRunner
//
//  Created by HLKJ on 15-5-5.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "UIView+Frame.h"




@implementation OrderListTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.orderId=[[UILabel alloc]init];
        self.orderId.font=[UIFont systemFontOfSize:13];
        [self.orderId setTintColor:[UIColor blackColor]];
        self.orderId.textAlignment=UITextAlignmentLeft;
        [self addSubview:self.orderId];
        
        self.orderIdValue=[[UILabel alloc]init];
        self.orderIdValue.font=[UIFont systemFontOfSize:13];
        [self.orderIdValue setTintColor:[UIColor blackColor]];
        self.orderIdValue.textAlignment=UITextAlignmentLeft;
        [self addSubview:self.orderIdValue];
        
        self.lineView=[[UIView alloc]init];
        [self.lineView setBackgroundColor:BackGray];
        [self addSubview:self.lineView];
        
        self.lineView1=[[UIView alloc]init];
        [self.lineView1 setBackgroundColor:BackGray];
        [self addSubview:self.lineView1];
        
        self.type=[[UILabel alloc]init];
        self.type.font=[UIFont systemFontOfSize:13.0];
        [self.type setTintColor:BackGray];
        self.type.textAlignment=UITextAlignmentLeft;
        [self addSubview:self.type];
        
        self.name=[[UILabel alloc]init];
        self.name.font=[UIFont systemFontOfSize:13];
        self.name.textAlignment=UITextAlignmentLeft;
        [self.name setTintColor:BackGray];
        [self addSubview:self.name];
        
        self.time=[[UILabel alloc]init];
        self.time.font=[UIFont systemFontOfSize:13];
        [self.time setTintColor:BackGray];
        self.time.textAlignment=UITextAlignmentLeft;
        [self addSubview:self.time];
        
        self.timeValue=[[UILabel alloc]init];
        self.timeValue.font=[UIFont systemFontOfSize:13];
        [self.timeValue setTintColor:BackGray];
        [self addSubview:self.timeValue];
        
        self.state=[[UILabel alloc]init];
        self.state.font=[UIFont systemFontOfSize:15];
        [self.state setTintColor:BackGray];
        [self addSubview:self.state];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.orderId.frame=CGRectMake(10, 3, self.frame.size.height/3+self.frame.size.height/4+13, self.frame.size.height/3);
    
    self.orderIdValue.frame=CGRectMake(self.frame.size.height/3+self.frame.size.height/4+13+10, 3, self.frame.size.width*2/3, self.frame.size.height/3);
    
    self.type.frame=CGRectMake(10, self.frame.size.height/3+6, self.frame.size.width/4, self.frame.size.height/4);
    
    self.name.frame=CGRectMake(self.frame.size.width/4+20, self.frame.size.height/3+6, self.frame.size.width/3, self.frame.size.height/4);
    
    self.time.frame=CGRectMake(10, self.frame.size.height/3+self.frame.size.height/4+9, self.frame.size.width/4, self.frame.size.height/4);
    
    self.timeValue.frame=CGRectMake(self.frame.size.width/4+20 , self.frame.size.height/3+self.frame.size.height/4+9, self.frame.size.width/3, self.frame.size.height/4);
    
    self.state.frame=CGRectMake(self.frame.size.width*4/5,self.frame.size.height/3+self.frame.size.height/4+9 , self.frame.size.width/5, self.frame.size.height/4);
    
    [GlobalMethod drawLineWithFrame:CGRectMake(10, self.frame.size.height+10, self.frame.size.width-20, 1.5) inView:self withColor:BackGray];
    self.lineView1.frame=CGRectMake(10, self.frame.size.height/3, self.width-20, 1);
    self.lineView.frame=CGRectMake(0, self.state.y+self.state.height, self.frame.size.width, self.height-self.state.y-self.state.height);
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
