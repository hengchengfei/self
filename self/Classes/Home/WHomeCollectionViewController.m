//
//  HomeCollectionViewController.m
//  self
//
//  Created by hengchengfei on 14/12/14.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "Reachability.h"
#import "WHomeCollectionViewController.h"
#import "WHomeCollectionViewCell.h"
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
#import "WHomeCollectionViewCell.h"
#import "NZCircularImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AMTagListView.h"
#import "TopicModel.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "UIView+Toast.h"
#import "ParamsUtils.h"
#import "RefreshControl.h"

#define WHomeLandscapeCommentCell @"WHomeLandscapeCommentCell"
#define WHomeLandscapeNoCommentCell @"WHomeLandscapeNoCommentCell"
#define WHomePortraitCommentCell @"WHomePortraitCommentCell"
#define WHomePortraitNoCommentCell @"WHomePortraitNoCommentCell"

@interface WHomeCollectionViewController()<RefreshControlDelegate>
{
    ImagesModel *imagesModel;
    NSUInteger page;
}

@property(nonatomic,assign)BOOL isLoading;

@property (nonatomic,strong)RefreshControl * refreshControl;

/**
 * 选中的segment
 */
@property(nonatomic)NSUInteger selectedSegmentIndex;

@end

@implementation WHomeCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupInit];
    [self addSegment];
    [self addPullToRefresh];
    //[self initData];
    //self.navigationController.hidesBarsOnSwipe=YES;
    
}


#pragma mark - 初始化操作
/**
 * 初始化操作
 *
 */
-(void)setupInit
{
    //背景色
    self.view.backgroundColor=UIColorFromRGB(MColorHomeBgd);
    
    //delegate
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    self.collectionView.alwaysBounceVertical=YES;//控制垂直方向是否一直反弹.如果没有数据或cell小于view高度,默认是NO,即没有下拉效果.
 
    
    page=1;
    
    //导航栏图片
    UIImage *whatImage =[UIImage imageNamed:@"top.png"];
    UIImageView *whatImageView=[[UIImageView alloc]initWithImage:whatImage];
    [whatImageView sizeToFit];
    self.navigationItem.titleView = whatImageView;
    
    //标签初始化
    [[AMTagView appearance] setTagLength:0];
    [[AMTagView appearance] setTextPadding:14];
    [[AMTagView appearance] setTextFont:[UIFont systemFontOfSize:14.0]];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(MColorTagBgd)];
    [[AMTagView appearance] setHoleRadius:0];
    [[AMTagView appearance] setInnerTagPadding:0.0];
    [[AMTagView appearance] setTextPadding:8.0];
    [[AMTagView appearance] setTextColor:UIColorFromRGB(MColorTagTxt)];
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"WHomeLandscapeCommentCell" bundle:nil] forCellWithReuseIdentifier:WHomeLandscapeCommentCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WHomeLandscapeNoCommentCell" bundle:nil] forCellWithReuseIdentifier:WHomeLandscapeNoCommentCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WHomePortraitCommentCell" bundle:nil] forCellWithReuseIdentifier:WHomePortraitCommentCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WHomePortraitNoCommentCell" bundle:nil] forCellWithReuseIdentifier:WHomePortraitNoCommentCell];
}

/**
 * 添加下拉刷新
 *
 */
-(void)addPullToRefresh
{
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_collectionView delegate:self];
    _refreshControl.topEnabled=YES;
    [self.refreshControl startRefreshingDirection:RefreshDirectionTop];
    
//    __weak typeof (self)weakself =self;
//    [self.collectionView addPullToRefreshActionHandler:^{
//        [weakself refreshGoodData];
//    }
//                                 ProgressImagesGifName:@"spinner_dropbox@2x.gif"
//                                  LoadingImagesGifName:@"run@2x.gif"
//                               ProgressScrollThreshold:60
//                                 LoadingImageFrameRate:30];
}

/**
 * 添加segment
 *
 */
-(void)addSegment
{
    PPiFlatSegmentItem *item1=[[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"精选",nil) andIcon:nil];
    PPiFlatSegmentItem *item2 = [[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"最新",nil) andIcon:nil];
    PPiFlatSegmentItem *item3 = [[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"关注",nil) andIcon:nil];
    NSArray *items = @[item1,item2,item3];
    PPiFlatSegmentedControl *segment = [[PPiFlatSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, WScreenSize.width, 44)
                                                                               items:items
                                                                        iconPosition:IconPositionRight
                                                                   andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                       self.selectedSegmentIndex = segmentIndex;
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
    [self.view insertSubview:segment aboveSubview:self.collectionView];
}

/**
 * 初始化数据
 * 默认加载精选数据
 */
-(void)initData
{
    if (![self isInternet]) {
        [self.view makeToast:@"服务器连接失败"
                    duration:1.0
                    position:CSToastPositionBottom];
        return;
    }

//    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view
//                                        title:@"加载中"
//                                         mode:MRProgressOverlayViewModeIndeterminateSmall
//                                     animated:YES];
//    [self loadGoodData];
}

#pragma mark RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    if (![self isInternet]) {
        [self.view makeToast:@"网络连接失败,请检查网络"
                    duration:1.0
                    position:CSToastPositionBottom];
        return;
    }
    
    //重新加载时,删除所有数据
    if (direction==RefreshDirectionTop)
    {
       [imagesModel.datas removeAllObjects] ;
        page=1;
    }
    else if(direction == RefreshDirectionBottom){
        page++;
    }
    
    if (self.selectedSegmentIndex==0) {
        [self loadGoodData];
        
    }
    
}

-(void)stopRefresh
{
    if (self.refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (self.refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }

}

#pragma mark - 加载数据

/**
 * 检测网络
 */
-(BOOL)isInternet
{
    Reachability *r=[Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus]==NotReachable) {
        return NO;
    }
    return YES;
}

/**
 * 加载"精选"数据
 */
-(void)loadGoodData
{
    [JSONHTTPClient setTimeoutInSeconds:60];
    [JSONHTTPClient postJSONFromURLWithString:WURLGetGoodContents
                                       params: [[ParamsUtils sharedParamsUtils] combineParams:@{@"page":[NSNumber numberWithInteger:page]}] //@{@"page":@"1"}
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                      // DLog(@"%@",json);
                                       NSError *error;
                                      ImagesModel *_imagesModel = [[ImagesModel alloc]initWithDictionary:json error:&error];
                                       if (!error && _imagesModel) {
                                           if (!imagesModel) {
                                               imagesModel = _imagesModel;
                                           }else{
                                               if (imagesModel.datas==nil) {
                                                   imagesModel.datas=_imagesModel.datas;
                                               }else{
                                                   for (ImageModel *image in _imagesModel.datas) {
                                                       [imagesModel.datas addObject:image];
                                                   }
                                               }
                                               
                                           }
                                           [self.collectionView reloadData];
                                       }else{
                                           [self.view makeToast:@"数据取得失败,请刷新重试"
                                                       duration:1.0
                                                       position:CSToastPositionBottom];
                                           page--;
                                       }
                                       [self stopRefresh];
                                       ///设置是否有下拉刷新
                                       if (_imagesModel.cPage <  _imagesModel.tPage)
                                       {
                                           self.refreshControl.bottomEnabled=YES;
                                       }
                                       else{
                                           self.refreshControl.bottomEnabled=NO;
                                       }
                                   }];
    
}

///**
// * 刷新"精选"数据
// */
//-(void)refreshGoodData
//{
//    __weak typeof(self) weakSelf = self;
//    self.isLoading = YES;
//    
//    [JSONHTTPClient setTimeoutInSeconds:60];
//    [JSONHTTPClient postJSONFromURLWithString:WURLGetGoodContents
//                                       params: [[ParamsUtils sharedParamsUtils] combineParams:@{@"page":@1}]
//                                   completion:^(NSDictionary *json, JSONModelError *err) {
//                                       DLog(@"%@",json);
//                                       NSError *error;
//                                       imagesModel = [[ImagesModel alloc]initWithDictionary:json error:&error];
//                                       if (imagesModel && imagesModel.datas.count>0) {
//                                           [self.collectionView reloadData];
//                                       }else{
//                                           [self.view makeToast:@"服务器连接失败"
//                                                       duration:1.0
//                                                       position:CSToastPositionBottom];
//                                       }
//                                       [weakSelf.collectionView stopRefreshAnimation];
//                                       weakSelf.isLoading=NO;
//                                       
//                                   }];
//    
//}



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
    
    [self loadGoodData];
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



#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageModel *data=[imagesModel.datas objectAtIndex:indexPath.row];
    
    //判断横竖
    BOOL isPortrait = NO;
    if(data.attachs && data.attachs.count>0){
        AttachmentModel *attach =  data.attachs[0];
        if([attach.width integerValue] < [attach.height integerValue]){
            isPortrait = YES;
        }
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //判断有无评论
    int ccnt = [data.cCnt intValue];
    if(isPortrait && ccnt > 0){
        return (CGSize){ width, 410.0 };
    }else if (isPortrait && ccnt <= 0){
        return (CGSize){ width, 380.0 };
    }else if (!isPortrait && ccnt > 0){
        return (CGSize){ width, 480.0 };
    }else if (!isPortrait && ccnt <= 0){
        return (CGSize){ width, 445.0 };
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
    
    ImageModel *data=[imagesModel.datas objectAtIndex:indexPath.row];
    
    NSString *identifier = WHomeLandscapeCommentCell;
    //判断横竖
    BOOL isPortrait = NO;
    if(data.attachs && data.attachs.count>0){
        AttachmentModel *attach =  data.attachs[0];
        if([attach.width integerValue] < [attach.height integerValue]){
            isPortrait = YES;
        }
    }
    
    //判断有无评论
    int ccnt = [data.cCnt intValue];
    if(isPortrait && ccnt > 0){
        identifier = WHomePortraitCommentCell;
    }else if (isPortrait && ccnt <= 0){
        identifier = WHomePortraitNoCommentCell;
    }else if (!isPortrait && ccnt > 0){
        identifier = WHomeLandscapeCommentCell;
    }else if (!isPortrait && ccnt <= 0){
        identifier = WHomeLandscapeNoCommentCell;
    }
    
    
    WHomeCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    
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
