//
//  WLabelView.m
//  self
//
//  Created by hengchengfei on 15/1/5.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WImageView.h"
#import "WLabelView.h"
#import "UIViewAdditions.h"
#import "ImageUtils.h"

@interface WImageView()

@property(nonatomic,strong)WLabelView *titleLabel;
@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation WImageView

-(id)initWithImageAndTitle:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
   self = [super initWithFrame:frame];
    if (self) {
        [self setupInit:image title:title];
    }
    
    return self;
}

-(void)setupInit:(UIImage *)image  title:(NSString *)title
{
    if (!image) {
        image =[[ImageUtils sharedImageUtils]imageWithColor:[UIColor grayColor]];
    }
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imageView.image=image;
    [self addSubview:imageView];
    
    if (title) {
        CGRect rect = CGRectMake(0, self.height-50, self.width, 40);
        WLabelView* labelView = [[WLabelView alloc]initWithFrame:rect title:title];
        [self addSubview:labelView];
    }

}

-(void)setLabelDirection:(LabelDirection)direction
{
    
}

@end