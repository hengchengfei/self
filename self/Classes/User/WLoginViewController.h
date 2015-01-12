//
//  WLoginViewController
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^blockLogin) (BOOL isSuccess);

@interface WLoginViewController : UIViewController

//@property(nonatomic)BOOL isSuccess;

@property(nonatomic,strong)blockLogin onCompleteLogin;

@end