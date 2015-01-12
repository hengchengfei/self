//
//  CreateViewControllwe.m
//  self
//
//  Created by hengchengfei on 14/12/21.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "LoginViewController.h"
#import "WUserUtils.h"
#import "WeiboSDK.h"

@interface LoginViewController()
{
    
}

@end

@implementation LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupInit];
    
}

-(void)setupInit
{
    
}

-(IBAction)close:(id)sender
{
    UITabBarController* root =(UITabBarController*)self.view.window.rootViewController;
    [self.view.window setRootViewController:root];
    root.selectedIndex=[[WUserUtils sharedWUserUtils]getTagOfLastTabItem]-2000;
}

-(IBAction)weiboLogin:(id)sender
{
    
    WBAuthorizeRequest* request = [WBAuthorizeRequest request];
    request.redirectURI=__WeiboRedictUrl__;
    request.scope = @"all";
    request.userInfo=@{@"user":@"hcf"};
    [WeiboSDK sendRequest:request];

}

-(IBAction)weiboLogout:(id)sender
{
    
    WBAuthorizeRequest* request = [WBAuthorizeRequest request];
    request.redirectURI=__WeiboRedictUrl__;
    request.scope = @"all";
    request.userInfo=@{@"user":@"hcf"};
    [WeiboSDK sendRequest:request];
    
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    DLog(@"%@",request);
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    DLog(@"%@",response);
}

#pragma mark -
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

-(void)successLogin
{
    
    //    [[WUserUtils sharedWUserUtils]setLoginStatus:YES];
    //    [[WUserUtils sharedWUserUtils]setLoginUserId:1243555];
    //
    //    UITabBarController* root =(UITabBarController*)self.view.window.rootViewController;
    //    [self.view.window setRootViewController:root];
    //    root.selectedIndex=[[WUserUtils sharedWUserUtils]getTagOfLastTabItem]-2000;
}
@end