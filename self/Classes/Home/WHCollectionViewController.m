//
//  HomeCollectionViewController.m
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "Reachability.h"
#import "WHCollectionViewController.h"
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

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

@interface WHCollectionViewController()
{
    ImagesModel *imagesModel;
}
@end

@implementation WHCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(MColorHomeBgd);

    
 
    
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

    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.collectionView];

//    __weak typeof (self)weakself =self;
//    [self.collectionView addPullToRefreshActionHandler:^{
//        
//    }
//                                 ProgressImagesGifName:@"spinner_dropbox@2x.gif"
//                                  LoadingImagesGifName:@"run@2x.gif"
//                               ProgressScrollThreshold:60
//                                 LoadingImageFrameRate:30];
//    
//    [self.collectionView addTopInsetInPortrait:10 TopInsetInLandscape:52];

//        self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.collectionView
//                                                                                target:self
//                                                                         refreshAction:@selector(refreshTriggered:)
//                                                                                 plist:@"storehouse"
//                                                                                 color:[UIColor whiteColor]
//                                                                             lineWidth:1.5
//                                                                            dropHeight:80
//                                                                                 scale:1
//                                                                  horizontalRandomness:150
//                                                               reverseLoadingAnimation:YES
//                                                               internalAnimationFactor:0.5];
    

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
    PPiFlatSegmentedControl *segment = [[PPiFlatSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, WScreenSize.width, 44)
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
                                           [self.collectionView reloadData];
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

    [self.collectionView setTop:44];
    if (iPhone4) {
        [self.collectionView setHeight:364];
    }else if(iPhone5){
        [self.collectionView setHeight:465];
    }else if(iPhone6){
        [self.collectionView setHeight:550];
    }else if(iPhone6plus){
        [self.collectionView setHeight:580];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageModel *data=[imagesModel.datas objectAtIndex:indexPath.row];
    
    //判断横竖
    BOOL isPortrait = NO;
    if(data.attachs && data.attachs.count>0){
        AttachmentModel *attach =  data.attachs[0];
        isPortrait = attach.isPortrait;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //判断有无评论
    int ccnt = [data.cCnt intValue];
    if(isPortrait && ccnt > 0){
        return (CGSize){ width, 410.0 };
    }else if (isPortrait && ccnt <= 0){
         return (CGSize){ width, 380.0 };
    }else if (!isPortrait && ccnt > 0){
         return (CGSize){ width, 410.0 };
    }else if (!isPortrait && ccnt <= 0){
        return (CGSize){ width, 380.0 };
    }
    
    return (CGSize){ width, 410.0 };
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (imagesModel) {
        return imagesModel.datas.count;
    }
    return 0;
}

/**
 * 重用cell
 * (注意:每次cell显示时,都会调用此方法,所以在其中的添加操作一定要注意)
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellLandscapeComment = @"whImageCollectionViewCellLandscapeComment";//横屏
    static NSString *cellLandscapeNoComment = @"whImageCollectionViewCellLandscapeNoComment";//横屏
    static NSString *cellPortraitComment = @"whImageCollectionViewCellPortraitComment";
    static NSString *cellPortraitNoComment = @"whImageCollectionViewCellPortraitNoComment";
    ImageModel *data=[imagesModel.datas objectAtIndex:indexPath.row];
    
    NSString *identifier = cellLandscapeComment;
    //判断横竖
    BOOL isPortrait = NO;
    if(data.attachs && data.attachs.count>0){
        AttachmentModel *attach =  data.attachs[0];
        isPortrait = attach.isPortrait;
    }
    
    //判断有无评论
    int ccnt = [data.cCnt intValue];
    if(isPortrait && ccnt > 0){
        identifier = cellPortraitComment;
    }else if (isPortrait && ccnt <= 0){
        identifier = cellPortraitNoComment;
    }else if (!isPortrait && ccnt > 0){
        identifier = cellLandscapeComment;
    }else if (!isPortrait && ccnt <= 0){
        identifier = cellLandscapeNoComment;
    }
    

    WHImageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    
    
    //时间
    NSDate *ctime =[JSONValueTransformer NSDateFromMilliseconds: data.cTime];
    NSString *timeInterval = [JSONValueTransformer timeIntervalFromDate:ctime endDate:[NSDate date]];
    cell.labelTimeInterval.text = timeInterval;
    
    //用户
    UserModel *user = data.user;
    if (user) {
        cell.labelName.text=user.name;
        [cell.imageViewMale setImageWithResizeURL:user.headUrl
                                 placeholderImage:[UIImage imageNamed:@"male_placeholder.png"]
                      usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    //图片
    DLog(@"%@",data);
    if(data.attachs && data.attachs.count>0){
      AttachmentModel *attach =  data.attachs[0];
        [cell.imageViewContent setImageWithURL:attach.url
                              placeholderImage:[UIImage imageNamed:isPortrait?@"image_placeholder_portrait.png":@"image_placeholder_landscape.png"]
                   usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        if (attach.title) {
            cell.labelTitle.text = attach.title;
            cell.labelTitle.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:attach.title];
            NSMutableParagraphStyle *style=[[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
            style.firstLineHeadIndent=20;//首行头缩进
            [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attach.title.length)];
            
            [cell.labelTitle setAttributedText:attrString];
        }
    }
    
    
    //评论者
    if(ccnt>0 && data.comments.count>0){
        CommentModel *comment = data.comments[0];
        cell.labelCommentContent.text = comment.text;
        if (comment.user && comment.user.headUrl) {
            [cell.imageViewCommentMale setImageWithResizeURL:comment.user.headUrl
                                     placeholderImage:[UIImage imageNamed:@"male_placeholder.png"]
                          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }

    //赞,看
    [cell.btnPraised setTitle:[NSString stringWithFormat:@"%d",[data.pCnt intValue]] forState:UIControlStateNormal];
    [cell.btnWatched setTitle:[NSString stringWithFormat:@"%d",[data.lCnt intValue]] forState:UIControlStateNormal];
    
    //标签
    //[cell.tagListView removeAllTags];
    if(cell.tagListView && cell.tagListView.tags.count<=0 && data.topics && data.topics.count >0){
        for (int i=0; i<data.topics.count; i++) {
            TopicModel *t= data.topics[i];

                        AMTagView *tag = [[AMTagView alloc]initWithFrame:CGRectZero];
                        NSString *name = t.name;
                        [tag setupWithText:name];
            
                        tag.tag=t.id;
                        [cell.tagListView addTagView:tag];
        }
        // __weak AMViewController* weakSelf = self;
        [cell.tagListView setTapHandler:^(AMTagView *view) {
            //weakSelf.selection = view;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
//                                                            message:@"as"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Nope"
//                                                  otherButtonTitles:@"Sure!", nil];
//            [alert show];
            NSLog(@"%ld",view.tag);
            
        }];
    }


    
    
    
    return cell;
}
 
@end
