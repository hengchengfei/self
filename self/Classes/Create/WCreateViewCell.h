//
//  WTopicCollectionViewCell.h
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLabelView.h"

typedef void (^blockPhotoLibrary)(id);
typedef UIImage* (^blockPhotoCamera)(id sender);
typedef void (^blockTextFieldShow)(id sender);
typedef void (^blockTextFieldHidden)(id sender);

@interface WCreateViewCell : UICollectionViewCell


/**
 * 块处理
 */
@property(nonatomic,strong)blockPhotoLibrary didClickPhotoSelect;
@property(nonatomic,strong)blockPhotoCamera didClickPhotoCamera;
@property(nonatomic,strong)blockTextFieldShow didTextfieldShow;
@property(nonatomic,strong)blockTextFieldHidden didTextfieldHidden;



@property(nonatomic,weak)IBOutlet WLabelView *titleLabel;

@property(nonatomic,weak)IBOutlet UIImageView *imageView;

@property(nonatomic,weak)IBOutlet UITextField *textField;

@property(nonatomic,weak)IBOutlet UIButton *btnPhotoSelect;

@property(nonatomic,weak)IBOutlet UIButton *btnPhotoCamera;

@property(nonatomic,weak)IBOutlet UIButton *btnPhotoDelete;

@property(nonatomic,weak)IBOutlet UISwitch *uiSwitch;

@property(nonatomic,weak)UIViewController *viewController;



-(void)setImageCamera:(blockPhotoCamera)photoCamera;

@end