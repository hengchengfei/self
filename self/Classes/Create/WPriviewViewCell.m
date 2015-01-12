//
//  WTopicCollectionViewCell.m
//  self
//
//  Created by hengchengfei on 14/12/16.
//  Copyright (c) 2014年 hcf. All rights reserved.
//

#import "WPriviewViewCell.h"
#import "JSONHTTPClient.h"
#import "ParamsUtils.h"
#import "TopicsModel.h"
#import "ImageUtils.h"

@interface WPriviewViewCell()<UIScrollViewDelegate,UITextFieldDelegate>
{
    TopicsModel* _topicsModel;
}



@end

@implementation WPriviewViewCell

-(void)awakeFromNib
{
    //暂时不添加标签
    //[self loadTaglist];
    
    self.scrollview.pagingEnabled=YES;
    self.scrollview.contentSize=CGSizeMake(WScreenSize.width*2, 320);
    self.scrollview.showsHorizontalScrollIndicator=NO;
    self.scrollview.delegate = self;
    
    self.textTopic.delegate=self;
    self.pagecontrol.currentPage = 0;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x -pageWidth/2)/pageWidth) +1;
    self.pagecontrol.currentPage = page;
}

-(void)hiddenPageControl:(BOOL)isHidden
{
    if (isHidden) {
        self.pagecontrol.hidden=YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textfieldBeginEditing:self];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate textfieldEndEditing:self];
}

#pragma mark - 添加标签
-(void)loadTaglist
{
    [JSONHTTPClient setTimeoutInSeconds:60];
    [JSONHTTPClient postJSONFromURLWithString:WURLGetHotTopics
                                       params: [[ParamsUtils sharedParamsUtils] combineParams:nil]
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       //DLog(@"%@",json);
                                       NSError *error;
                                       _topicsModel = [[TopicsModel alloc]initWithDictionary:json error:&error];
                                       if (!error && _topicsModel && _topicsModel.datas.count>0) {
                                           [self addTagToView];
                                       }else{
//                                           [self.view makeToast:@"话题取得失败"
//                                                       duration:1.0
//                                                       position:CSToastPositionBottom];
                                       }
                                       
                                   }];
}

/**
 * 添加标签
 */
-(void)addTagToView
{
    if(_topicsModel && _topicsModel.datas.count > 0){
        
        for (int i=0; i<_topicsModel.datas.count; i++) {
            AMTagView *tag = [[AMTagView alloc]initWithFrame:CGRectZero];
            tag.backgroundColor=[UIColor clearColor];
            [tag setTagColor:[UIColor grayColor]];
            TopicModel* topic =_topicsModel.datas[i];
            [tag setupWithText:topic.name];
            [self.tagListView addTagView:tag];
        }
    }
}

@end