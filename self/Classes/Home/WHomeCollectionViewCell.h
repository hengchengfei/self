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

@interface WHomeCollectionViewCell : UICollectionViewCell

/**
* 头像
*
*/
@property(nonatomic,weak)IBOutlet NZCircularImageView *imageViewMale;

/**
 * 图片
 *
 */
@property(nonatomic,weak)IBOutlet UIImageView *imageViewContent;

/**
 * 作者标签
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelName;

/**
 * 图片标题标签
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelTitle;

/**
 * 时间间隔标签
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelTimeInterval;

/**
 * 关注按钮
 *
 */
@property(nonatomic,weak)IBOutlet UIButton *btnAttention;

/**
 * 评论者头像
 *
 */
@property(nonatomic,weak)IBOutlet NZCircularImageView *imageViewCommentMale;

/**
 * 评论内容
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelCommentContent;

/**
 * 看按钮
 *
 */
@property(nonatomic,weak)IBOutlet UIButton *btnWatched;

/**
 * 赞按钮
 *
 */
@property(nonatomic,weak)IBOutlet UIButton *btnPraised;

/**
 *tag标签组
 */
@property(nonatomic,weak)IBOutlet AMTagListView *tagListView;

@end