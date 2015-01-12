//
//  CreateViewControllwe.m
//  self
//
//  Created by hengchengfei on 14/12/21.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "WCameraViewController.h"

@interface WCameraViewController()

@property(nonatomic,weak)IBOutlet UIImageView *imageview;

@end


@implementation WCameraViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finish:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCamera object:nil userInfo:@{@"image":self.image}];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
 
    self.imageview.image = self.image;
    
}

@end