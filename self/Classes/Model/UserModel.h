//
//  UserModel.h
//  self
//
//  内容模型
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

#import "JSONModel.h"

@protocol UserModel @end

@interface UserModel : JSONModel

@property(nonatomic,assign)long long id;

/** 创建者 */
@property(nonatomic,strong)NSString* name;

/** 头像 */
@property(nonatomic,strong)NSString* headUrl;


@end
