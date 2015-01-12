//
//  MainTabController.m
//  ada
//
//  Created by heng chengfei on 14-10-27.
//  Copyright (c) 2014年 csf. All rights reserved.
//

#import "WTabViewController.h"
#import "WLoginViewController.h"
#import "WUserUtils.h"

@interface WTabViewController()
{
    WLoginViewController *loginViewController;
}
@end

@implementation WTabViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
 
    self.delegate=self;

    //首页
    UITabBarItem *item0=[self.tabBar.items objectAtIndex:0];
    item0.tag=2000;
    UIImage *item0Image  = [UIImage imageNamed:@"tab_home.png"];
    UIImage *item0ImageSelected =[UIImage imageNamed:@"tab_home_selected.png"];
    item0Image = [item0Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0ImageSelected = [item0ImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置为图片本来颜色，否则会被系统设置为默认蓝色
    [item0 setImage:item0Image];
    [item0 setSelectedImage:item0ImageSelected];

    UIColor *color = [UIColor blackColor];
    NSDictionary *dict= [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont fontWithName:@"AmericanTypewriter"
                                         size:10.0f],
                         NSFontAttributeName,
                         color,
                         NSForegroundColorAttributeName,
                         nil];
    
    //设置选择时，文本颜色
    [item0 setTitleTextAttributes:dict forState:UIControlStateSelected];

    
    //发现
    UITabBarItem *item1=[self.tabBar.items objectAtIndex:1];
    item1.tag=2001;
    UIImage *item1Image  = [UIImage imageNamed:@"tab_find.png"];
    UIImage *item1ImageSelected =[UIImage imageNamed:@"tab_find_selected.png"];
    item1Image = [item1Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1ImageSelected = [item1ImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置为图片本来颜色，否则会被系统设置为默认蓝色
    [item1 setImage:item1Image];
    [item1 setSelectedImage:item1ImageSelected];
    //设置选择时，文本颜色
    [item1 setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    //submit
    UITabBarItem *item2=[self.tabBar.items objectAtIndex:2];
    item2.tag=2002;
    UIImage *item2Image  = [UIImage imageNamed:@"tab_create.png"];
    UIImage *item2ImageSelected =[UIImage imageNamed:@"tab_create.png"];
    item2Image = [item2Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2ImageSelected = [item2ImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置为图片本来颜色，否则会被系统设置为默认蓝色
    [item2 setImage:item2ImageSelected];
    [item2 setSelectedImage:item2ImageSelected];
    item2.imageInsets=UIEdgeInsetsMake(7, 0, -4, 0);
 
    //like
    UITabBarItem *item3=[self.tabBar.items objectAtIndex:3];
    item3.tag=2003;
    UIImage *item3Image  = [UIImage imageNamed:@"tab_message.png"];
    UIImage *item3ImageSelected =[UIImage imageNamed:@"tab_message_selected.png"];
    item3Image = [item3Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3ImageSelected = [item3ImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置为图片本来颜色，否则会被系统设置为默认蓝色
    [item3 setImage:item3Image];
    [item3 setSelectedImage:item3ImageSelected];
    //设置选择时，文本颜色
    [item3 setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    //me
    UITabBarItem *item4=[self.tabBar.items objectAtIndex:4];
    item4.tag=2004;
    UIImage *item4Image  = [UIImage imageNamed:@"tab_personal.png"];
    UIImage *item4ImageSelected =[UIImage imageNamed:@"tab_personal.png"];
    item4Image = [item4Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4ImageSelected = [item4ImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置为图片本来颜色，否则会被系统设置为默认蓝色
    [item4 setImage:item4Image];
    [item4 setSelectedImage:item4ImageSelected];
    //设置选择时，文本颜色
    [item4 setTitleTextAttributes:dict forState:UIControlStateSelected];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
 
    if (item.tag==2002) {
        [[WUserUtils sharedWUserUtils]setIsCameraOrPhoto:NO];
    }else{
        [[WUserUtils sharedWUserUtils]setTagOfLastTabItem:item.tag];
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers
{
    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
 
}
@end