//
//  NumberUtils.m
//  self
//
//  Created by hengchengfei on 14/12/25.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "NumberUtils.h"

@implementation NumberUtils

+(NSString *)randFileName
{
    //获取系统时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    
    NSString *dateStr =[dateFormatter stringFromDate:[NSDate date]];
    
    //随即5位数
    NSMutableString *randStr=[[NSMutableString alloc]init];
    for (int i=0; i<5; i++) {
        int val =arc4random()%10;
        [randStr appendString:[NSString stringWithFormat:@"%d",val]];
    }
    
    return [NSString stringWithFormat:@"W%@%@",dateStr,randStr];
}

@end
