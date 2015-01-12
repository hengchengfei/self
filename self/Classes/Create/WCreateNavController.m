//
//  WCreateNavController.m
//  self
//
//  Created by hengchengfei on 15/1/10.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCreateNavController.h"
#import "WUserUtils.h"
#import "WCreateViewController.h"
#import "LoginViewController.h"

@interface WCreateNavController()
@end

@implementation WCreateNavController

-(void)viewDidLoad
{
    [super viewDidLoad];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL isCamera =  [[WUserUtils sharedWUserUtils]getIsCameraOrPhoto];
    if (isCamera) {
        return;
    }
    
    BOOL islogin = [[WUserUtils sharedWUserUtils]getLoginStatus];
    if (islogin) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WCreateViewController* ctl =  [storyboard instantiateViewControllerWithIdentifier:@"wCreateViewController"];
        [[WUserUtils sharedWUserUtils]setIsCameraOrPhoto:NO];
        [self setViewControllers:[NSArray arrayWithObject: ctl]];
    }else{
        LoginViewController* ctl = [[LoginViewController alloc]init];
        [self setViewControllers:[NSArray arrayWithObject:ctl]];
    }
}

@end