//
//  WServerRequest.m
//  self
//
//  Created by hengchengfei on 15/1/9.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WServerRequest.h"

@implementation WServerRequest

DEFINE_SINGLETON_FOR_CLASS(WServerRequest)

-(NSDictionary *)get:(NSString *)url params:(NSString *)params
{
    url =[url stringByAppendingString:params];
    //url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@",url);
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:120];
    [request setHTTPShouldHandleCookies:false];
    [request setHTTPMethod:@"GET"];
    
    NSError *error1;
    NSHTTPURLResponse *response;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
    // NSInteger statusCode= response.statusCode;
    if (error1!=nil) {
        DLog(@"%@",error1);
        return error1.userInfo;
    }
    
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
    if (dictionary==nil) {
        DLog(@"WebRequest.h服务器数据取得失败:%@",returnData);
        NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Json取得失败" forKey:NSLocalizedDescriptionKey];
        dictionary =errorDict;
    }
    return dictionary;
}

-(NSDictionary *)post:(NSString *)url params:(NSString *)params
{
    url =[url stringByAppendingString:params];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@",url);
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:120];
    [request setHTTPShouldHandleCookies:false];
    [request setHTTPMethod:@"POST"];
    
    NSError *error1;
    NSHTTPURLResponse *response;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
    // NSInteger statusCode= response.statusCode;
    if (error1!=nil) {
        DLog(@"%@",error1);
        return error1.userInfo;
    }
    
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
    if (dictionary==nil) {
        DLog(@"WebRequest.h服务器数据取得失败:%@",returnData);
        NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Json取得失败" forKey:NSLocalizedDescriptionKey];
        dictionary =errorDict;
    }
    return dictionary;
}
@end