//
//  CommentModel.h
//  self
//
//  评论模型
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

#import "JSONModel.h"
#import "UserModel.h"

@protocol CommentModel
@end

@interface CommentModel : JSONModel

@property(nonatomic,assign)long long id;

/** 创建者 */
@property(nonatomic,strong)UserModel* user;

/** 评论被赞数量 */
@property(nonatomic,strong)NSNumber<Optional> *pCnt;

/** 评论关联的内容id */
@property(nonatomic,strong)NSNumber<Optional> *conId;

/** 评论内容 */
@property(nonatomic,strong)NSString<Optional>* text;

/** 创建时间 */
@property(nonatomic,strong)NSNumber<Optional>* cTime;


@end
