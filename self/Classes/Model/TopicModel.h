//
//  TopicModel.h
//  self
//
//  话题模型
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

@protocol TopicModel @end

#import "JSONModel.h"
#import "ImageModel.h"



@interface TopicModel : JSONModel

@property(nonatomic,assign)long long id;

/** 话题名 */
@property(nonatomic,strong)NSString<Optional>* name;

/** 创建时间 */
@property(nonatomic,strong)NSNumber<Optional>* cTime;

/** 参与人数 */
@property(nonatomic,strong)NSNumber<Optional>* pCnt;

/** 相关话题 */
@property(nonatomic,strong)NSArray<ImageModel,Optional> *contents;


@end
