//
//  UIImage+tool.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tool)

// 通过颜色获取图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


// 缩放图片
- (UIImage *)scaleToSize:(CGSize)size;


@end
