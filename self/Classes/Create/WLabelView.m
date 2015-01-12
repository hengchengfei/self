//
//  WLabelView.m
//  self
//
//  Created by hengchengfei on 15/1/5.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLabelView.h"
#import "UIViewAdditions.h"

@interface WLabelView()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *backgroundView;

@end

@implementation WLabelView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
   self = [super initWithFrame:frame];
    if (self) {
        [self setupInit:title];
    }
    
    return self;
}

-(void)setupInit:(NSString *)title
{
    self.backgroundColor=[UIColor clearColor];
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.backgroundView.backgroundColor=[UIColor blackColor];
    self.backgroundView.alpha=0.3;
    [self addSubview:self.backgroundView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self setTitle:title];
    
    [self addSubview:self.titleLabel];
}


-(void)setTitle:(NSString *)title
{
    NSMutableParagraphStyle* style=[[NSMutableParagraphStyle alloc]init];
    style.firstLineHeadIndent = 10.f;
    
    if (title) {
           self.titleLabel.attributedText =[[NSAttributedString alloc]initWithString:title attributes:@{NSParagraphStyleAttributeName:style}];
    }
}

-(NSString *)getTitle
{
    return self.titleLabel.text;
}

@end