//
//  HomeCollectionViewController.m
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "Reachability.h"
#import "WHomeViewController.h"
#import "UIViewController+ScrollingNavbar.h"
#import "UIViewAdditions.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "JSONHTTPClient.h"
#import "ImageModel.h"
#import "AttachmentModel.h"
#import "JSONValueTransformer+NSDate.h"
#import "ImagesModel.h"
#import "MRProgressOverlayView.h"
#import "WHImageCollectionViewCell.h"
#import "NZCircularImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AMTagListView.h"
#import "TopicModel.h"
#import "WHomeViewCell.h"

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

@interface WHomeViewController()<UITableViewDataSource,UITableViewDelegate>
{
    ImagesModel *imagesModel;
}


@end

@implementation WHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(MColorHomeBgd);

    [self.tableview registerClass:[WHomeViewCell class] forCellReuseIdentifier:@"cell123"];
    
    UINib *nib=[UINib nibWithNibName:@"WHomeCell" bundle:nil];
    
    [self.tableview registerNib:nib forCellReuseIdentifier:@"mycell"];
    self.tableview.backgroundView=nil;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.backgroundColor=[UIColor greenColor];
    [self loadData];
    
    //
//    [self.collectionView setTop:44];
//    if (iPhone4) {
//        [self.collectionView setHeight:404];
//    }else if(iPhone5){
//        [self.collectionView setHeight:464];
//    }else if(iPhone6){
//        [self.collectionView setHeight:555];
//    }else if(iPhone6plus){
//        [self.collectionView setHeight:614];
//    }
//    __weak typeof (self)weakself =self;
//    [self.collectionView addPullToRefreshActionHandler:^{
//        
//    }
//                                        ProgressImagesGifName:@"spinner_dropbox@2x.gif"
//                                         LoadingImagesGifName:@"run@2x.gif"
//                               ProgressScrollThreshold:60
//                                LoadingImageFrameRate:30];
//    // If you did not change scrollview inset, you don't need code below.
//    if(IS_IOS7)
//        [self.collectionView addTopInsetInPortrait:34 TopInsetInLandscape:52];
//    else if(IS_IOS8)
//    {
//        CGFloat landscapeTopInset = 32.0;
//        if(iPhone6plus)
//            landscapeTopInset = 44.0;
//        [self.collectionView addTopInsetInPortrait:64 TopInsetInLandscape:landscapeTopInset];
//    }
    
//    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.collectionView
//                                                                            target:self
//                                                                     refreshAction:@selector(refreshTriggered:)
//                                                                             plist:@"storehouse"
//                                                                             color:[UIColor grayColor]
//                                                                         lineWidth:1.5
//                                                                        dropHeight:80
//                                                                             scale:1
//                                                              horizontalRandomness:150
//                                                           reverseLoadingAnimation:YES
//                                                           internalAnimationFactor:0.5];
    
//    [self.collectionView setDelegate:self];
//    [self.collectionView setDataSource:self];
    
    // Just call this line to enable the scrolling navbar
    //[self followScrollView:self.collectionView];


    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    
    //add the image to navigation bar
    UIImage *whatImage =[UIImage imageNamed:@"top.png"];
    UIImageView *whatImageView=[[UIImageView alloc]initWithImage:whatImage];
    [whatImageView sizeToFit];
    self.navigationItem.titleView = whatImageView;
    
    
    //添加tab按钮
    PPiFlatSegmentItem *item1=[[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"精选",nil) andIcon:nil];
    PPiFlatSegmentItem *item2 = [[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"最新",nil) andIcon:nil];
    PPiFlatSegmentItem *item3 = [[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"关注",nil) andIcon:nil];
    NSArray *items = @[item1,item2,item3];
    PPiFlatSegmentedControl *segment = [[PPiFlatSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, WScreenSize.width, 44)
                                                                               items:items
                                                                        iconPosition:IconPositionRight
                                                                   andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                       
                                                                   }
                                                                      iconSeparation:5];

    segment.color=UIColorFromRGB(MColorSegBgd);
    segment.selectedColor=UIColorFromRGB(MColorSegBgd);//选中时覆盖的颜色,一定要设置,否则默认为parent view的背景色
    
    segment.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:UIColorFromRGB(MColorSegTxt)};
    segment.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                       NSForegroundColorAttributeName:UIColorFromRGB(MColorSegTxtSelected)};
    [segment.layer setMasksToBounds:YES];
    [segment.layer setCornerRadius:0.0];//设置control四个角度的度数,0为直角.
//    segment.layer.borderWidth=1;
//    segment.layer.borderColor = [UIColor greenColor].CGColor;
    
    UIView *lineView =[[UIView alloc]initWithFrame:segment.frame];
    [lineView setTop:segment.size.height-1];
    [lineView setHeight:1];
    [lineView setBackgroundColor:UIColorFromRGB(MColorSegSplit)];
    [segment addSubview:lineView];
    //[segment setSegmentAtIndex:1 enabled:YES];
    [self.view addSubview:segment];
    
    //标签
    [[AMTagView appearance] setTagLength:0];
    [[AMTagView appearance] setTextPadding:14];
    [[AMTagView appearance] setTextFont:[UIFont systemFontOfSize:14.0]];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(MColorTagBgd)];
    [[AMTagView appearance]setHoleRadius:0];
    [[AMTagView appearance]setInnerTagPadding:0.0];
    [[AMTagView appearance] setTextPadding:8.0];
    [[AMTagView appearance] setTextColor:UIColorFromRGB(MColorTagTxt)];
    
}



-(void)loadData
{
    MRProgressOverlayView *pview = [MRProgressOverlayView new];
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
    [pview show:YES];
 
    [JSONHTTPClient setTimeoutInSeconds:60];
    [JSONHTTPClient postJSONFromURLWithString:WRGetLatest
                                       params:@{@"page":@"1"}
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       [pview dismiss:YES];
                                       
                                       NSError *error;
                                       imagesModel = [[ImagesModel alloc]initWithDictionary:json error:&error];
                                       if (imagesModel && imagesModel.datas.count>0) {
                                           [self.tableview reloadData];
                                       }else{
                                           [MRProgressOverlayView showOverlayAddedTo:self.view title:@"服务器连接失败" mode:MRProgressOverlayViewModeCross animated:YES];
                                           [self performBlock:^{
                                              [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                                           } afterDelay:1.0];
                                       }
                                       
//                                       ImageModel *m0=imagesModel.datas[0];
//                                       JSONValueTransformer *j = [[JSONValueTransformer alloc]init];
//                                       NSNumber *time = m0.cTime;
//                                       NSLog(@"%lld",LONG_LONG_MAX);
//                                       long long time1 = time.longLongValue;
//                                       NSDate *da = [NSDate dateWithTimeIntervalSince1970:time1];
//                                       
//                                       DLog(@"%@",[j NSDateFromMilliseconds:m0.cTime]);
                                       
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

//    [self.collectionView setTop:50];
//    if (iPhone4) {
//        [self.collectionView setHeight:364];
//    }else if(iPhone5){
//        [self.collectionView setHeight:340];
//    }else if(iPhone6){
//        [self.collectionView setHeight:550];
//    }else if(iPhone6plus){
//        [self.collectionView setHeight:580];
//    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self showNavBarAnimated:NO];
}

#pragma mark UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //点击状态栏,出现导航栏
    // This enables the user to scroll down the navbar by tapping the status bar.
    [self showNavbar];
 
    return YES;
}


#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 410;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (imagesModel) {
//        return imagesModel.datas.count;
//    }
    return 2;
}

/**
 * 重用cell
 * (注意:每次cell显示时,都会调用此方法,所以在其中的添加操作一定要注意)
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    WHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    cell.labelName.text=@"aaa";
    
    return cell;
}
 
@end
