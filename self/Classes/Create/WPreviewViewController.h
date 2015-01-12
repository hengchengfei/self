//
//  CreateViewController.h
//  self
//
//  Created by hengchengfei on 14/12/21.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

typedef NS_ENUM(NSInteger, TitleDirection)
{
    Top = 0,
    Middle = 1,
    Bottom = 2
};

@interface WPreviewViewController : UIViewController

@property(nonatomic,strong)UIImage *imageFront;
@property(nonatomic,strong)UIImage *imageBack;
@property(nonatomic,strong)NSString *titleFront;
@property(nonatomic,strong)NSString *titleBack;
@property(nonatomic)TitleDirection directionFront;
@property(nonatomic)TitleDirection directionBack;

@end