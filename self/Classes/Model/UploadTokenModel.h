//
//  UploadTokenModel.h
//  self
//
//  七牛上传token模型
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

#import "JSONModel.h"

@protocol UploadTokenModel @end

@interface UploadTokenModel : JSONModel

/** 返回状态 */
@property(nonatomic,assign)int status;

/** 状态信息 */
@property(nonatomic,strong)NSString<Optional>* msg;

/** token */
@property(nonatomic,strong)NSString<Optional>* token;

@end
