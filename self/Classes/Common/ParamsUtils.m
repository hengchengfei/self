//
//  ParamsUtils.m
//  self
//
//  Created by hengchengfei on 14/12/27.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamsUtils.h"
#import "Reachability.h"

@implementation ParamsUtils

DEFINE_SINGLETON_FOR_CLASS(ParamsUtils)

-(NSDictionary *)AppParams
{
    //网络信息
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
    NSString* _net=@"wifi";
    if (reachability.isReachableViaWWAN) {
        _net = @"2g/3g";
    }
    
    //版本信息
    NSDictionary *infoDict =[[NSBundle mainBundle]infoDictionary];
    NSString *_version =[infoDict objectForKey:@"CFBundleVersion"];
    
    //设备信息
    UIDevice *device_=[[UIDevice alloc] init];
//    NSLog(@"设备所有者的名称－－%@",device_.name);
//    NSLog(@"设备的类别－－－－－%@",device_.model);
//    NSLog(@"设备的的本地化版本－%@",device_.localizedModel);
//    NSLog(@"设备运行的系统－－－%@",device_.systemName);
//    NSLog(@"当前系统的版本－－－%@",device_.systemVersion);
//    NSLog(@"设备识别码－－－－－%@",device_.identifierForVendor.UUIDString);
    return @{@"_source":@"ios",@"_version":_version,@"_net":_net,@"_model":device_.model,@"_uuid":device_.identifierForVendor.UUIDString};
}

-(NSMutableDictionary *)combineParams:(NSDictionary *)params
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]initWithDictionary:[self AppParams]];
    if (params) {
        [result setValuesForKeysWithDictionary:params];
    }   

    return result;
}
@end