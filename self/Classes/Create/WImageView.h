//
//  WLabelView.h
//  self
//
//  Created by hengchengfei on 15/1/5.
//  Copyright (c) 2015年 hcf. All rights reserved.
//
typedef NS_ENUM(NSInteger, LabelDirection)
{
    LabelDirectionTop = 0,
    LabelDirectionMiddle = 1,
    LabelDirectionBottom = 2
};

@interface WImageView : UIView

-(id)initWithImageAndTitle:(CGRect)frame  image:(UIImage *)image title:(NSString *)title;


-(void)setLabelDirection:(LabelDirection)direction;

@end