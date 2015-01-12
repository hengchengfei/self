//
//  ContentModel.h
//  self
//
//  内容模型
//
//  (协议需要放在import之前,否则会出现循环引用的问题)
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

@protocol ImageModel @end

#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import "AttachmentModel.h"
#import "UserModel.h"
#import "CommentModel.h"
#import "TopicModel.h"

@interface ImageModel : JSONModel

@property(nonatomic,assign)long long id;
 
/** 内容类型 */
@property(nonatomic,strong)NSNumber<Optional>* type;

/** 创建者 */
@property(nonatomic,strong)UserModel<Optional>* user;

/** 赞数量 */
@property(nonatomic,strong)NSNumber<Optional>*  pCnt;

/** 评论数量 */
@property(nonatomic,strong)NSNumber<Optional>*  cCnt;

/** 浏览数量 */
@property(nonatomic,strong)NSNumber<Optional>* lCnt;

/** 创建时间 */
@property(nonatomic,strong)NSNumber<Optional>* cTime;

/** 评论内容 */
@property(nonatomic,strong)NSArray<CommentModel,Optional,ConvertOnDemand> *comments;

/** 附件 */
@property(nonatomic,strong)NSArray<AttachmentModel,Optional,ConvertOnDemand> *attachs;

/** 关联话题 */
@property(nonatomic,strong)NSArray<TopicModel,Optional> *topics;

@end
