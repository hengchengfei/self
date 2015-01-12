//
//  WHTopCollectionViewCell.h
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"
#import "AMTagListView.h"

@interface WHomeViewCell : UITableViewCell

/**
* 头像
*
*/
@property(nonatomic,strong)IBOutlet NZCircularImageView *imageViewMale;

/**
 * 图片
 *
 */
@property(nonatomic,strong)IBOutlet UIImageView *imageViewContent;

/**
 * 作者标签
 *
 */
@property(nonatomic,strong)IBOutlet UILabel *labelName;

/**
 * 图片标题标签
 *
 */
@property(nonatomic,strong)IBOutlet UILabel *labelTitle;

/**
 * 时间间隔标签
 *
 */
@property(nonatomic,strong)IBOutlet UILabel *labelTimeInterval;

/**
 * 关注按钮
 *
 */
@property(nonatomic,strong)IBOutlet UIButton *btnAttention;

/**
 * 评论者头像
 *
 */
@property(nonatomic,strong)IBOutlet NZCircularImageView *imageViewCommentMale;

/**
 * 评论内容
 *
 */
@property(nonatomic,strong)IBOutlet UILabel *labelCommentContent;

/**
 * 看按钮
 *
 */
@property(nonatomic,strong)IBOutlet UIButton *btnWatched;

/**
 * 赞按钮
 *
 */
@property(nonatomic,strong)IBOutlet UIButton *btnPraised;

/**
 *tag标签组
 */
@property(nonatomic,strong)IBOutlet AMTagListView *tagListView;

@end