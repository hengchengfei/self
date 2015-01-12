//
//  CreateViewControllwe.m
//  self
//
//  Created by hengchengfei on 14/12/21.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "WPreviewViewController.h"
#import "WLabelView.h"
#import "ImageUtils.h"
#import "AMTagListView.h"
#import "JSONHTTPClient.h"
#import "ParamsUtils.h"
#import "TopicsModel.h"
#import "UIView+Toast.h"
#import "WPriviewViewCell.h"
#import "WImageView.h"
#import "UIViewAdditions.h"
#import "MRProgressOverlayView.h"
#import "UploadTokenModel.h"
#import "QNUploadManager.h"
#import "NumberUtils.h"
#import "QNUploadOption.h"
#import "WServerRequest.h"
#import "QNResponseInfo.h"

@interface WPreviewViewController()<UITableViewDataSource,UITableViewDelegate,WPriviewViewCellDelegate>
{
    
}

@property(nonatomic,weak)IBOutlet UITableView *tableview;



@end

@implementation WPreviewViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupInit];
    
}

-(void)setupInit
{
    
    
    
    self.tableview.dataSource=self;
    self.tableview.delegate = self;
    self.tableview.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.tableHeaderView =[[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIButton *buttonBack=[[UIButton alloc]init];
    //buttonBack.backgroundColor = [UIColor greenColor];
    buttonBack.frame = CGRectMake(0, 0, 50, 23);
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemClose=[[UIBarButtonItem alloc]initWithCustomView:buttonBack];
    
    
    UIButton *button=[[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 50, 23);
    [button setTitle:@"上传" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    NSArray *arrItems =[NSArray arrayWithObjects:item, nil];
    self.navigationItem.rightBarButtonItems=arrItems;
    self.navigationItem.leftBarButtonItems=@[itemClose];
    
    //    self.imageView.image =[[ImageUtils sharedImageUtils] imageWithColor:[UIColor grayColor]];
    //    if (self.imageFront) {
    //        self.imageView.image = self.imageFront;
    //    }
    //
    //    if (self.titleFront) {
    //        [self.titleView setupInit:self.titleFront];
    //    }
    
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)publish:(id)sender
{
    [self uploadImage];
}

-(NSString *)getParams:(NSString *)title order:(NSInteger)order
{
    
    NSMutableDictionary*  params = [[NSMutableDictionary alloc]init];
    [params setObject:@1 forKey:@"userId"];
    [params setObject:@0 forKey:@"type"];
    [params setObject:[NSNumber numberWithInteger:order] forKey:@"order"];
    [params setObject:title?title:@"" forKey:@"title"];
    
    WPriviewViewCell* cell = (WPriviewViewCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* topic = cell.textTopic.text;
    
    NSMutableArray*  titlesArr =[[NSMutableArray alloc]init];
    if (topic) {
        NSMutableDictionary* titles0 =[NSMutableDictionary dictionaryWithObject:topic forKey:@"name"];
        [titlesArr addObject:titles0];
    }else{
        NSMutableDictionary* titles0 =[NSMutableDictionary dictionaryWithObject:@"test" forKey:@"name"];
        [titlesArr addObject:titles0];
    }
    [params setObject:titlesArr forKey:@"topics"];
    NSData *paramsdata=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paramsjson= [[NSString alloc]initWithData:paramsdata encoding:NSUTF8StringEncoding];
    
    return paramsjson;
}

-(NSData *)getUploadImageOfFirst
{
    return UIImageJPEGRepresentation(self.imageFront, 1.0);
}

-(NSData *)getUploadImageOfSecond
{
    return UIImageJPEGRepresentation(self.imageBack, 1.0);
}

-(NSDictionary *)getUploadParamsOfFirst
{
    NSString* title = self.titleFront;
    NSString *params = [self getParams:title order:0];
    
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return @{@"x:params":params};
}
-(NSDictionary *)getUploadParamsOfSecond
{
    NSString* title = self.titleBack;
    NSString *params = [self getParams:title order:1];
    
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return @{@"x:params":params};
}

/**
 *
 */
-(void)uploadImage
{
    if(!self.imageFront){
        return;
    }
    
    MRProgressOverlayView *pview = [MRProgressOverlayView new];
    pview.titleLabelText=@"上传中...";
    pview.mode=MRProgressOverlayViewModeIndeterminate;
    [self.navigationController.view addSubview:pview];//注意先后顺序
    [pview show:YES];
    
    //params = [@"?params=" stringByAppendingString:params];
    //NSDictionary* result = [[WServerRequest sharedWServerRequest]post:WURLCallBackUpload params:params];
    
    [JSONHTTPClient setTimeoutInSeconds:60];
    [JSONHTTPClient postJSONFromURLWithString:WURLGetUploadToken
                                       params:nil
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       UploadTokenModel*  tokenmodel = [[UploadTokenModel alloc]initWithDictionary:json error:nil];
                                       QNUploadManager*   upManager  = [QNUploadManager sharedInstanceWithRecorder:nil recorderKeyGenerator:nil];
                                       __block QNUploadOption*    opt        = [[QNUploadOption alloc] initWithMime:nil
                                                                                                    progressHandler:nil
                                                                                                             params:[self getUploadParamsOfFirst]
                                                                                                           checkCrc:NO
                                                                                                 cancellationSignal:nil];
                                       
                                       [upManager putData:[self getUploadImageOfFirst]
                                                      key:[NumberUtils randFileName]
                                                    token:tokenmodel.token
                                                 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                                                     //第二个图
//                                                     if (!info.error) {
//                                                         opt  = [[QNUploadOption alloc] initWithMime:nil
//                                                                                     progressHandler:nil
//                                                                                              params:[self getUploadParamsOfSecond]
//                                                                                            checkCrc:NO
//                                                                                  cancellationSignal:nil];
//                                                         
//                                                         [upManager putData:[self getUploadImageOfSecond]
//                                                                        key:[NumberUtils randFileName]
//                                                                      token:tokenmodel.token
//                                                                   complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                                                                       if (info.error) {
//                                                                           [self showMessage:@"上传失败" mode:MRProgressOverlayViewModeCross];
//                                                                       }else{
//                                                                           [self showMessage:@"上传成功" mode:MRProgressOverlayViewModeCheckmark];
//                                                                           self.navigationController.tabBarController.selectedIndex=0;
//                                                                       }
//                                                                       
//                                                                       [pview dismiss:YES];
//                                                                       
//                                                                   } option:opt];
//                                                     }else{
//                                                         [pview dismiss:YES];
//                                                         [self showMessage:@"上传失败" mode:MRProgressOverlayViewModeCross];
//                                                     }
                                                     [pview dismiss:YES];
                                                     [self showMessage:@"上传成功" mode:MRProgressOverlayViewModeCheckmark];
                                                     
                                                     self.view.window.rootViewController = self.tabBarController;
                                                     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                                     int tag = [[defaults objectForKey:wLastTabItem]intValue]-2000;
                                                     self.tabBarController.selectedIndex=tag;
                                                     
                                                 } option:opt];
                                   }];
}

-(void)showMessage:(NSString *)message mode:(MRProgressOverlayViewMode)mode
{
    MRProgressOverlayView *pview = [MRProgressOverlayView new];
    pview.titleLabelText=message;
    pview.mode=mode;
    [self.navigationController.view addSubview:pview];//注意先后顺序
    [pview show:YES];
    
    [self performBlock:^{
        [pview dismiss:YES];
    } afterDelay:0.5];
}

/**
 * 延迟几秒后执行block处理
 *
 */
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -WPriviewViewCellDelegate
-(void)textfieldBeginEditing:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.tableview setTop:-200];
    }];
}

-(void)textfieldEndEditing:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.tableview setTop:0];
    }];
}


#pragma mark - UITableViewDataSource+UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"wPriviewCell";
    
    WPriviewViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.pagecontrol.numberOfPages = 2;//固定为2页
    if(self.imageFront){
        WImageView* view=[[WImageView alloc]initWithImageAndTitle:CGRectMake(0, 0, WScreenSize.width, WScreenSize.width)
                                                            image:self.imageFront
                                                            title:self.titleFront];
        [cell.scrollview addSubview:view];
        if (self.imageBack) {
            WImageView* view1=[[WImageView alloc]initWithImageAndTitle:CGRectMake(320, 0, WScreenSize.width, WScreenSize.width)
                                                                 image:self.imageBack
                                                                 title:self.titleBack];
            [cell.scrollview addSubview:view1];
        }
    }else{
        WImageView* view=[[WImageView alloc]initWithImageAndTitle:CGRectMake(0, 0, WScreenSize.width, WScreenSize.width)
                                                            image:[[ImageUtils sharedImageUtils]imageWithColor:[UIColor grayColor]]
                                                            title:self.titleFront];
        [cell.scrollview addSubview:view];
        if (!self.imageBack) {
            WImageView* view1=[[WImageView alloc]initWithImageAndTitle:CGRectMake(320, 0, WScreenSize.width, WScreenSize.width)
                                                                 image:[[ImageUtils sharedImageUtils]imageWithColor:[UIColor grayColor]]
                                                                 title:self.titleBack];
            [cell.scrollview addSubview:view1];
        }
    }
    
    return cell;
}


 

@end