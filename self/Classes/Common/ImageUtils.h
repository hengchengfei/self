//
//  ImageUtils.h
//  self
//
//  Created by hengchengfei on 15/1/4.
//  Copyright (c) 2015年 hcf. All rights reserved.
//

@interface ImageUtils : NSObject

DEFINE_SINGLETON_FOR_HEADER(ImageUtils);

/**
 * color转换为image
 */
-(UIImage *)imageWithColor:(UIColor *)color;

/**
 * 图片缩放
 */
-(UIImage *) imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;
@end