//
//  WCreateNavController.m
//  self
//
//  Created by hengchengfei on 15/1/10.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMessageNavController.h"
#import "WUserUtils.h"
#import "WMessageViewController.h"
#import "LoginViewController.h"

@interface WMessageNavController()
@end

@implementation WMessageNavController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL islogin = [[WUserUtils sharedWUserUtils]getLoginStatus];
    if (islogin) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WMessageViewController* ctl =  [storyboard instantiateViewControllerWithIdentifier:@"wMessageViewController"];
        [[WUserUtils sharedWUserUtils]setIsCameraOrPhoto:NO];
        [self setViewControllers:[NSArray arrayWithObject: ctl]];
    }else{
        LoginViewController* ctl = [[LoginViewController alloc]init];
        [self setViewControllers:[NSArray arrayWithObject:ctl]];
    }
}

@end