//
//  AppDelegate.m
//  self
//
//  Created by hengchengfei on 14/11/21.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "WUserUtils.h"
#import "LoginViewController.h"
#import "WeiboSDK.h"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[WUserUtils sharedWUserUtils]setLoginStatus:NO];
    
    //[[UINavigationBar appearance] setTranslucent:YES]; //首页的导航栏需要,其他页面设置为yes,否则影响起始位置
 
    //part3
    [self startupInit];
    
    return YES;
}

-(void)startupInit
{
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:__WeiboAppKey__];
    
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //登录成功,则保存用户信息
        if (response.statusCode ==WeiboSDKResponseStatusCodeSuccess) {
           // [WUserUtils sharedWUserUtils]setValue:<#(id)#> forKey:<#(NSString *)#>
        }
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        DLog(@"%@",(WBAuthorizeResponse *)response.userInfo);
        // self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        NSString* wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        NSDictionary* dict  = (WBAuthorizeResponse *)response.userInfo;
        [alert show];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}

//-(void)reachabilityChanged:(NSNotification *)note
//{
//    Reachability *reach = [note object];
//    reach.reachableBlock=^(Reachability *reachability){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.window makeToast:@"网络可用" duration:1.0 position:CSToastPositionBottom];
//        });
//    };
//    
//    reach.unreachableBlock=^(Reachability *reachability){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.window makeToast:@"网络连接失败" duration:1.0 position:CSToastPositionBottom];
//        });
//    };
//    
//}

//- (void)updateInterfaceWithReachability:(Reachability *)curReach
//{
//    if (curReach == hostReach)
//    {
//        [self configureTextField:remoteHostStateField imageView:remoteHostIcon reachability:curReach];
//        NetworkStatus netStatus = [curReach currentReachabilityStates];
//        BOOL connectionRequired = [curReach connectionRequired];
//        
//        summaryLabel.hidden = (netStatus != ReachabilityViaWWAN);
//        NSString *baseLabel = @"";
//        if (connectionRequired)
//        {
//            baseLabel = @"Cellular data network is available.\n Internet traffic will be routed through it after a connection is established.";
//        }
//        else
//            　　　　 {
//                baseLabel = @"Cellular data network is active.\n Internet traffic will be routed through it.";
//            }
//        summaryLabel.text = baseLabel;
//    }
//    if (curReach == internetReach)
//    {
//        [self configureTextField:internetConnectionStatusField imageView:internetConnectionIcon reachability:curReach];
//    }
//    if (curReach == wifiReach)
//    {
//        [self configureTextField:localWiFiConnectionStatusField imageView:localWiFiConnectionIcon reachability:curReach];
//    }
//}

//- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)curReach
//{
//    NetworkStatus netStatus = [curReach currentReachabilityStatus];
//    BOOL connectionRequired = [curReach connectionRequired];
//    NSString *statusString = @"";
//    switch (netStatus)
//    {
//        case NotReachable:
//        {
//            statusString = @"Access Not Available";
//            imageView.image = [UIImage imageNamed:@"stop-32.png"];
//            connectionRequired = NO;
//            
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            statusString = @"Reachable WWAN";
//            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
//            
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            statusString = @"";
//            imageView.image = [UIImage imageNamed:@"Airport.png"];
//            
//            break;
//        }
//    }
//    if (connectionRequired)
//    {
//        statusString = [NSString stringWithFormat:@"%@, Connection Required", statusString];
//    }
//    textField.text = statusString;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
