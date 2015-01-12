//
//  HomeCollectionViewController.h
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//
#import <UIKit/UIKit.h>

@class CBStoreHouseRefreshControl;
//typedef enum {
//    UIImageRoundedCornerTopLeft = 1,
//    UIImageRoundedCornerTopRight = 1 << 1,
//    UIImageRoundedCornerBottomRight = 1 << 2,
//    UIImageRoundedCornerBottomLeft = 1 << 3
//} UIImageRoundedCorner;

@interface WHCollectionViewController : UICollectionViewController

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;


@end