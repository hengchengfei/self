//
//  WServerRequest.h
//  self
//
//  Created by hengchengfei on 15/1/9.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

@interface WUserUtils : NSObject

DEFINE_SINGLETON_FOR_HEADER(WUserUtils);

-(void)setLoginStatus:(BOOL)status;
-(BOOL)getLoginStatus;
-(void)setLoginUserId:(long long)userId;
-(long long)getLoginUserId;
-(void)removeUserId;


-(void)setTagOfLastTabItem:(int)index;
-(int)getTagOfLastTabItem;

-(void)setIsCameraOrPhoto:(BOOL)isCamera;
-(BOOL)getIsCameraOrPhoto;

@end