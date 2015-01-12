//
//  JSONValueTransformer+NSDate.h
//  self
//
//  Created by hengchengfei on 14/12/15.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (NSDate)

/**
 * 毫秒级转换为日期
 * @param 毫秒
 * @return 日期
 */
+(NSDate *)NSDateFromMilliseconds:(NSNumber *)number;


/**
 * 日期转换为字符串
 * @param 日期
 * @return 字符串
 */
+(NSString*)JSONObjectFromNSDate:(NSDate*)date;


/**
 * 计算两个日期的时间差
 * @param fromDate 开始日期
 * @param endDate 结束日期
 * @return 时间差
 */
+(NSString *)timeIntervalFromDate:(NSDate *)fromDate endDate:(NSDate *)endDate;

@end
