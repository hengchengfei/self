//
//  ImageUtils.m
//  self
//
//  Created by hengchengfei on 15/1/4.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUtils.h"

@implementation ImageUtils

DEFINE_SINGLETON_FOR_CLASS(ImageUtils)


-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIImage *) imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}
@end