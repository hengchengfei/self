//
//  WTopicCollectionViewCell.h
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"
#import "AMTagListView.h"

@interface WTopicCollectionViewCell : UICollectionViewCell

/**
 * 话题名
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelName;

/**
 * 参与人数
 *
 */
@property(nonatomic,weak)IBOutlet UILabel *labelCnt;

/**
 * 图片
 *
 */
@property(nonatomic,weak)IBOutlet UIScrollView *scrollView;


@end