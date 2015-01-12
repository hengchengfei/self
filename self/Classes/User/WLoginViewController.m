//
//  WLoginViewController
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "WLoginViewController.h"

@interface WLoginViewController()

@end

@implementation WLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.translucent=YES;
}

-(IBAction)didClickBack:(id)sender{
    self.onCompleteLogin(NO);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
