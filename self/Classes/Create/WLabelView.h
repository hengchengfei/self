//
//  WLabelView.h
//  self
//
//  Created by hengchengfei on 15/1/5.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

@interface WLabelView : UIView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;

/**
 * 初始化操作
 */
-(void)setupInit:(NSString *)title;

-(void)setTitle:(NSString *)title;

-(NSString *)getTitle;


@end