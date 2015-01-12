//
//  CreateViewControllwe.m
//  self
//
//  Created by hengchengfei on 14/12/21.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "WCreateViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SevenSwitch.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "WPreviewViewController.h"
#import "WCreateViewCell.h"
#import "QiniuSDK.h"
#import "UploadTokenModel.h"
#import "JSONHTTPClient.h"
#import "MRProgressOverlayView.h"
#import "NumberUtils.h"
#import "UIViewAdditions.h"
#import "SCNavigationController.h"
#import "WCameraViewController.h"
#import "WUserUtils.h"

@interface WCreateViewController()<UICollectionViewDataSource,UICollectionViewDelegate,SCNavigationControllerDelegate>
{
    
    WPreviewViewController *controller;
    WCameraViewController *cameraController;
    
    QNUploadManager *upManager;
    UIImageView *imageView;
    NSString *imageName;
    NSMutableDictionary* params;
    
    NSMutableArray* titlesArr;
    
    float collectionViewStartX;
    
    int selectCellIndex;
}

@property(nonatomic,weak)IBOutlet UICollectionView *collectionView;
@property(nonatomic) UIImagePickerController *picker1;
@end

@implementation WCreateViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupInit];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)dealloc
{
  [self configureNotification:NO];
}

#pragma mark - init
-(void)setupInit
{
    [self configureNotification:YES];
    
    collectionViewStartX = self.collectionView.frame.origin.y;
    self.collectionView.dataSource=self;
    self.collectionView.delegate = self;
    
//    //导航栏
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//    label.text=@"创作中";
//    label.font=[UIFont systemFontOfSize:19.0];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.textColor = [UIColor grayColor];
//    self.navigationItem.titleView = label;
//    
//    UIButton *buttonClose=[[UIButton alloc]init];
//    //    [button setBackgroundImage:back forState:UIControlStateNormal];
//    buttonClose.frame = CGRectMake(0, 0, 50, 23);
//    [buttonClose setTitle:@"关闭" forState:UIControlStateNormal];
//    [buttonClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [buttonClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *itemClose=[[UIBarButtonItem alloc]initWithCustomView:buttonClose];
//    self.navigationItem.leftBarButtonItems=@[itemClose];
    
    //键盘事件
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap0];
    [self.navigationController.view addGestureRecognizer:tap1];
}

-(void)hiddenKeyboard
{
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
}
-(IBAction)close:(id)sender
{
    //UITabBarController *t=  self.tabBarController;
    UITabBarController *t1=  self.navigationController.tabBarController;
    //t.selectedIndex =1;
    t1.selectedIndex =0;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"wCreateViewCell";
    WCreateViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.viewController=self;
    cell.didTextfieldShow=^(id sender){
        if (indexPath.row==1) {
            [UIView animateWithDuration:0.3f animations:^{
                [self.collectionView setTop:self.collectionView.frame.origin.y-240];
            }];
        }
    };
    cell.didTextfieldHidden=^(id sender){
        if (indexPath.row==1) {
            [UIView animateWithDuration:0.3f animations:^{
                [self.collectionView setTop:collectionViewStartX];
            }];
        }
    };
 
    cell.didClickPhotoCamera =^UIImage *(id sender){
            selectCellIndex = indexPath.row;
            SCNavigationController *nav = [[SCNavigationController alloc] init];
            nav.scNaigationDelegate = self;
            [nav showCameraWithParentController:self];
        return nil;
    };

    return cell;
}

/**
 * 拍照通知
 *
 */
- (void)configureNotification:(BOOL)toAdd {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCamera object:nil];
    if (toAdd) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callbackNotificationForFilter:) name:kNotificationCamera object:nil];
    }
}

-(void)callbackNotificationForFilter:(NSNotification *)notification
{
   NSDictionary *dict = notification.userInfo;
   UIImage *image=[dict objectForKey:@"image"];
    if (image) {
        DLog(@"----%@",NSStringFromCGSize(image.size))
        WCreateViewCell* cell = (WCreateViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectCellIndex inSection:0]];
        cell.imageView.image=image;
    }

}
-(void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image
{
    UIStoryboard* storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    cameraController  = [storyboard instantiateViewControllerWithIdentifier:@"wCameraViewController"];
    cameraController.image = image;
    [navigationController pushViewController:cameraController animated:YES];
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
 
/**
 * 延迟几秒后执行block处理
 *
 */
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hiddenKeyboard];
    if ([@"gotoWPriview" isEqualToString:segue.identifier]) {
        WPreviewViewController* pcontroller =  segue.destinationViewController;
        
        WCreateViewCell* cell0= (WCreateViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
       DLog(@"----2%@",NSStringFromCGSize(cell0.imageView.image.size))
        pcontroller.imageFront = cell0.imageView.image;
        pcontroller.directionFront = cell0.uiSwitch.on?1:2;
        NSString *titleFront =[cell0.titleLabel getTitle];
        if (titleFront && ![@"" isEqualToString:titleFront]) {
           pcontroller.titleFront = titleFront;
        }
        
        WCreateViewCell* cell1= (WCreateViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        pcontroller.imageBack = cell1.imageView.image;
        pcontroller.directionBack = cell1.uiSwitch.on?1:2;
        NSString *titleBack =[cell1.titleLabel getTitle];
        if (titleBack && ![@"" isEqualToString:titleBack]) {
            pcontroller.titleBack = titleBack;
        }
    }
    
    
}

@end