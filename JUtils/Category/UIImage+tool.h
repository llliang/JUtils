//
//  UIImage+tool.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tool)

/// 通过颜色获取图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/// 缩放图片
- (UIImage *)scaleToSize:(CGSize)size;

/*
 @brief 单张图片压缩 为了应对data 转成uiimage size 变大的问题 统一返回data格式
 @pragma size 尺寸
 @pragma fileSize eg:100*1024 // 100k 最低参考值
 */
+ (void)compressImage:(UIImage *)image toSize:(CGSize)size referenceFileSize:(double)fileSize result:(void(^)(NSData *imageData))result;

/*
 @brief 单张图片压缩 为了应对data 转成uiimage size 变大的问题 统一返回data格式
 @pragma size 尺寸
 @pragma fileSize eg:100*1024 // 100k 最低参考值
 */
+ (void)compressImages:(NSArray<UIImage *> *)images toSize:(CGSize)size referenceFileSize:(double)fileSize result:(void(^)(NSArray<NSData *> *imageDatas))result;

@end
