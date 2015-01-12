//
//  ContentsModel.h
//  self
//
//  内容模型
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

#import "JSONModel.h"
#import "TopicModel.h"


@interface TopicsModel : JSONModel

/** 返回时间 */
@property(nonatomic,assign)long long timestamp;

/** 返回状态 */
@property(nonatomic,assign)int status;

/** 当前页码 */
@property(nonatomic,assign)int cPage;

/** 列表数据 */
@property(nonatomic,retain)NSMutableArray<TopicModel,Optional,ConvertOnDemand> *datas;

@end
