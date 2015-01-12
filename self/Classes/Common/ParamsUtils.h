//
//  ParamsUtils.h
//  self
//
//  Created by hengchengfei on 14/12/27.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

@interface ParamsUtils : NSObject

DEFINE_SINGLETON_FOR_HEADER(ParamsUtils);

-(NSDictionary *)AppParams;

-(NSMutableDictionary *)combineParams:(NSDictionary *)p1;

@end