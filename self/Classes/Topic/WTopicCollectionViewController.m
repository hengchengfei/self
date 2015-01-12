//
//  HomeCollectionViewController.m
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "Reachability.h"
#import "WTopicCollectionViewController.h"
#import "WTopicCollectionViewCell.h"
#import "UIViewController+ScrollingNavbar.h"
#import "UIViewAdditions.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "JSONHTTPClient.h"
#import "AttachmentModel.h"
#import "JSONValueTransformer+NSDate.h"
#import "ImagesModel.h"
#import "MRProgressOverlayView.h"
#import "NZCircularImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AMTagListView.h"
#import "TopicModel.h"
#import "TopicsModel.h"

@interface WTopicCollectionViewController()
{
    TopicsModel *topicsModel;
}
@end

@implementation WTopicCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.navigationController.navigationBar.translucent=YES;
    
//    __weak typeof (self)weakself =self;
//    [self.collectionView addPullToRefreshActionHandler:^{
//        
//    }
//                                 ProgressImagesGifName:@"spinner_dropbox@2x.gif"
//                                  LoadingImagesGifName:@"run@2x.gif"
//                               ProgressScrollThreshold:60
//                                 LoadingImageFrameRate:30];
//    
//    [self.collectionView addTopInsetInPortrait:64 TopInsetInLandscape:52];
    
    
    [self setNavBatTitle];
 
    [self loadData];
    
    
    
}


-(void)setNavBatTitle
{
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    label.text=@"话题";
    label.font=[UIFont systemFontOfSize:19.0];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    
    self.navigationItem.titleView = label;
}

-(void)loadData
{
    MRProgressOverlayView *pview = [MRProgressOverlayView new];
    [pview show:YES];
    [self.view addSubview:pview];

    
    Reachability *r=[Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus]==NotReachable) {
        pview.titleLabelText=@"网络连接失败";
        pview.mode=MRProgressOverlayViewModeCross;
        [self performBlock:^{
            [pview dismiss:YES];
        } afterDelay:2];
        return;
    }
    
    pview.titleLabelText=@"加载中";
    pview.mode=MRProgressOverlayViewModeIndeterminateSmall;
    
 
    [JSONHTTPClient setTimeoutInSeconds:60];
    [JSONHTTPClient postJSONFromURLWithString:WURLGetTopics
                                       params:@{@"page":@"1"}
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       [pview dismiss:YES];
                                       
                                       NSError *error;
                                       topicsModel = [[TopicsModel alloc]initWithDictionary:json error:&error];
                                       if (topicsModel && topicsModel.datas.count>0) {
                                           [self.collectionView reloadData];
                                       }else{
                                           [MRProgressOverlayView showOverlayAddedTo:self.view title:@"服务器连接失败" mode:MRProgressOverlayViewModeCross animated:YES];
                                           [self performBlock:^{
                                              [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                                           } afterDelay:1.0];
                                       }
 
                                   }];
    
}

/**
 * 延迟几秒后执行block处理
 *
*/
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){ WScreenSize.width, 150.0 };
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (topicsModel) {
        return topicsModel.datas.count;
    }
    return 0;
}

/**
 * 重用cell
 * (注意:每次cell显示时,都会调用此方法,所以在其中的添加操作一定要注意)
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel *data=[topicsModel.datas objectAtIndex:indexPath.row];
    
    static NSString *cellIndentifier = @"wTopicCollectionViewCell";//横屏
    
    WTopicCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];

    
    cell.labelName.text=data.name;
    cell.labelCnt.text=[NSString stringWithFormat:@"%d人参与",[data.pCnt intValue]];
    
    if (data.contents && data.contents.count>0) {
        for (UIView *view in cell.scrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        
        cell.scrollView.pagingEnabled=YES;
        cell.scrollView.contentSize=CGSizeMake(data.contents.count * 90, 90);
        cell.scrollView.showsHorizontalScrollIndicator=YES;
        cell.scrollView.delegate=self;
        
        int orgX = 3;
        for (ImageModel *image in data.contents) {
            AttachmentModel *attach = image.attachs[0];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(orgX, 0, 80, 80)];
            [imageView setImageWithURL:attach.url
                      placeholderImage:[UIImage imageNamed:@"image_placeholder_portrait.png"]
           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            [cell.scrollView addSubview:imageView];
            
            orgX = orgX +87;
        }
        
    }
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.translucent=YES;
}
 
@end
