//
//  MainTabController.m
//  ada
//
//  Created by heng chengfei on 14-10-27.
//  Copyright (c) 2014年 csf. All rights reserved.
//

#import "WMessageViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "PPiFlatSegmentItem.h"

#import "UIViewAdditions.h"

#import "WMessageReplyViewCell.h"
#import "WMessagePraiseViewCell.h"
#import "WMessageNotificationViewCell.h"

@interface WMessageViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSString* cellIndentifier;
}
@property(nonatomic,weak)IBOutlet UITableView *tableView;

@end

@implementation WMessageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setupInit];
   
    self.title = @"消息";
}

-(void)setupInit
{
    //背景色
    self.view.backgroundColor=UIColorFromRGB(MColorSegBgd);//设置背景色,status bar
    
    //delegate
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.alwaysBounceVertical=YES;//控制垂直方向是否一直反弹.如果没有数据或cell小于view高度,默认是NO,即没有下拉效果.
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.tableHeaderView=[[UIView alloc]init];
    cellIndentifier = @ "wMessageReplyViewCell";
    
    [self addSegment];
}

-(void)addSegment
{
    PPiFlatSegmentItem *item1=[[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"回复",nil) andIcon:nil];
    PPiFlatSegmentItem *item2 = [[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"赞",nil) andIcon:nil];
    PPiFlatSegmentItem *item3 = [[PPiFlatSegmentItem alloc]initWithTitle:NSLocalizedString(@"通知",nil) andIcon:nil];
    NSArray *items = @[item1,item2,item3];
    PPiFlatSegmentedControl *segment = [[PPiFlatSegmentedControl alloc]initWithFrame:CGRectMake(0, 20, WScreenSize.width, 44)
                                                                               items:items
                                                                        iconPosition:IconPositionRight
                                                                   andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                       switch (segmentIndex) {
                                                                           case 0:
                                                                               cellIndentifier = @ "wMessageReplyViewCell";
                                                                               break;
                                                                           case 1:
                                                                               cellIndentifier = @ "wMessagePraiseViewCell";
                                                                               break;
                                                                            case 2:
                                                                               cellIndentifier = @ "wMessageNotificationViewCell";
                                                                               break;
                                                                           default:
                                                                               break;
                                                                       }
                                                                       
                                                                       [self.tableView reloadData];
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
    [self.view insertSubview:segment aboveSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMessageReplyViewCell* cell =[tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    
    return cell;
}

@end