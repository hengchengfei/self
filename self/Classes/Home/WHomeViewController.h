//
//  HomeCollectionViewController.h
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface WHomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)IBOutlet UITableView *tableview;


@end