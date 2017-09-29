//
//  UIImage+tool.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "UIImage+tool.h"

@implementation UIImage (tool)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scaleToSize:(CGSize)size {
    CGSize originSize = self.size;  
    if (originSize.width <= size.width && originSize.height <= size.height) {
        return self;
    }  
    float originRatio = originSize.width/originSize.height;
    float ratio = size.width/size.height;
    CGSize resultSize = CGSizeZero;
    
    if (originRatio <= ratio) {
        if ( originSize.width >= size.width) {
            resultSize = CGSizeMake(size.width, size.width*originSize.height/originSize.width);
        }else {
            resultSize = CGSizeMake((originSize.width*size.height)/originSize.height, size.height);
        }
    } else {
        // 此种情况只有一种 originSize.width > size.width 
        resultSize = CGSizeMake(size.width, (size.width*originSize.height)/originSize.width);
    }
    UIGraphicsBeginImageContext(resultSize);
    [self drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (void)compressImage:(UIImage *)image toSize:(CGSize)size referenceFileSize:(double)fileSize result:(void(^)(NSData *imageData))result {
    
    __block CGFloat compression = 1.f;
    CGFloat minCompression = 0.1;

    UIImage *tempImage = [image scaleToSize:size];
    __block NSData *imageData = UIImageJPEGRepresentation(tempImage, compression);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (imageData.length > fileSize && compression > minCompression) {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(tempImage, compression);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(imageData);
        });
    });
}

+ (void)compressImages:(NSArray<UIImage *> *)images toSize:(CGSize)size referenceFileSize:(double)fileSize result:(void(^)(NSArray<NSData *> *imageDatas))result {
    
    __block CGFloat compression = 1.f;
    CGFloat minCompression = 0.1;
    
    __block NSMutableArray *resultImagesDatas = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (UIImage *image in images) {
            
            UIImage *tempImage = [image scaleToSize:size];
            __block NSData *imageData = UIImageJPEGRepresentation(tempImage, compression);

            while (imageData.length > fileSize && compression > minCompression) {
                compression -= 0.1;
                imageData = UIImageJPEGRepresentation(tempImage, compression);
            }
            [resultImagesDatas addObject:imageData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(resultImagesDatas);
        });
    });
}

@end
