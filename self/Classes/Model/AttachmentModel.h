//
//  AttachModel.h
//  self
//
//  附件模型 (切记前段与后端的model名称不能一致)
//
//  Created by heng chengfei on 14-12-14.
//  Copyright (c) 2014年 cf. All rights reserved.
//

#import "JSONModel.h"

@protocol AttachmentModel @end

@interface AttachmentModel : JSONModel


@property(nonatomic,assign)long long id;
 
/** 附件url地址 */
@property(nonatomic,strong)NSURL<Optional> *url;

/** 附件顺序 */
@property(nonatomic,strong)NSNumber<Optional> *order;

/** 附件标题 */
@property(nonatomic,strong)NSString<Optional> *title;

/** 宽度 */
@property(nonatomic,strong)NSNumber<Optional> *width;

/** 高度 */
@property(nonatomic,strong)NSNumber<Optional> *height;

@end
