//
//  WServerRequest.m
//  self
//
//  Created by hengchengfei on 15/1/9.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WUserUtils.h"

@implementation WUserUtils

DEFINE_SINGLETON_FOR_CLASS(WUserUtils)

-(void)setLoginStatus:(BOOL)status
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setObject:status?@(1):@(0) forKey:@"isLogin"];
    [user synchronize];
}

-(BOOL)getLoginStatus
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSNumber* status = [user objectForKey:@"isLogin"];
    if (status && [status integerValue]==1) {
        return YES;
    }else{
        return NO;
    }
}

-(void)setLoginUserId:(long long)userId
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setObject:@(userId) forKey:@"userId"];
    [user synchronize];
}

-(long long)getLoginUserId
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [user objectForKey:@"userId"];
    
    return [userId longLongValue];
}

-(void)removeUserId
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"userId"];
    [user synchronize];    
}

-(void)setTagOfLastTabItem:(int)index
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setObject:@(index) forKey:@"lastTabIndex"];
    [user synchronize];
}
-(int)getTagOfLastTabItem
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    return  [[user objectForKey:@"lastTabIndex"]intValue];
}

-(void)setIsCameraOrPhoto:(BOOL)isCamera
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setObject:isCamera?@(1):@(0) forKey:@"isCamera"];
    [user synchronize];
}
-(BOOL)getIsCameraOrPhoto{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    int status =  [[user objectForKey:@"isCamera"]intValue];
    return status==1?YES:NO;
}

@end