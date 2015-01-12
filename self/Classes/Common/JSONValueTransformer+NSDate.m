//
//  JSONValueTransformer+NSDate.m
//  self
//
//  Created by hengchengfei on 14/12/15.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "JSONValueTransformer+NSDate.h"

@implementation JSONValueTransformer (NSDate)


+(NSDate *)NSDateFromMilliseconds:(NSNumber *)number
{
    if (number) {
       long long time = number.longLongValue/1000;
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    return nil;
}

+(NSString*)JSONObjectFromNSDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter stringFromDate:date];
}


+(NSString *)timeIntervalFromDate:(NSDate *)fromDate endDate:(NSDate *)endDate
{
    NSString *timeString=@"";
    NSTimeInterval interval =fabs([endDate timeIntervalSinceDate:fromDate]);
    if (interval/3600 < 1) {
        timeString=[NSString stringWithFormat:@"%f",interval/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前",timeString];
    }
    
    if (interval/3600>1 && interval/86400<1) {
        timeString=[NSString stringWithFormat:@"%f",interval/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前",timeString];
        
        //        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        //        [dateformatter setDateFormat:@"HH:mm"];
        //        timeString = [NSString stringWithFormat:@"今天 %@",[dateformatter stringFromDate:ctime]];
    }
    
    if (interval/86400>1 && interval/2592000 < 1) {
        timeString=[NSString stringWithFormat:@"%f",interval/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前",timeString];
        
        //        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        //        [dateformatter setDateFormat:@"YY-MM-dd HH:mm"];
        //        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:ctime]];
    }
    
    if (interval/2592000 > 1 && interval/31104000 < 1) {
        timeString=[NSString stringWithFormat:@"%f",interval/2592000];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@个月前",timeString];
    }
    if (interval/31104000 > 1) {
        timeString=[NSString stringWithFormat:@"%f",interval/31104000];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@年前",timeString];
    }
    
    return timeString;
}

@end
