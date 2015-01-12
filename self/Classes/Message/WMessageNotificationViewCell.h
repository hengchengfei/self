//
//  WHTopCollectionViewCell.h
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"

@interface WMessageNotificationViewCell : UITableViewCell

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
 * 作者
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelAuthor;

/**
 *
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelComment;

/**
 * 时间间隔标签
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelTimeInterval;


@end