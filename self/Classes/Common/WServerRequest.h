//
//  WServerRequest.h
//  self
//
//  Created by hengchengfei on 15/1/9.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

@interface WServerRequest : NSObject

DEFINE_SINGLETON_FOR_HEADER(WServerRequest);

-(NSDictionary *)get:(NSString *)url params:(NSString *)params;
-(NSDictionary *)post:(NSString *)url params:(NSString *)params;

@end