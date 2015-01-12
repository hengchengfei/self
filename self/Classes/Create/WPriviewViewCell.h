//
//  WTopicCollectionViewCell.h
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLabelView.h"
#import "AMTagListView.h"

@protocol WPriviewViewCellDelegate <NSObject>

-(void)textfieldBeginEditing:(id)sender;
-(void)textfieldEndEditing:(id)sender;

@end

@interface WPriviewViewCell : UITableViewCell


@property(nonatomic,strong)id<WPriviewViewCellDelegate> delegate;

@property(nonatomic,weak)IBOutlet AMTagListView *tagListView;
@property(nonatomic,weak)IBOutlet UIScrollView *animationView;
@property(nonatomic,weak)IBOutlet UIScrollView *scrollview;
@property(nonatomic,weak)IBOutlet UIPageControl *pagecontrol;
@property(nonatomic,weak)IBOutlet UITextField *textTopic;

@end