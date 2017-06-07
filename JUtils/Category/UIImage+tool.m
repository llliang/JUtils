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
    if (originSize.width <= size.width && originSize.height < size.height) {
        return self;
    }
    float originRatio = size.width/size.height;
    CGSize resultSize = CGSizeZero;
    float ratio = originSize.width/originSize.height;
    
    if (ratio >= originRatio && originSize.width >= size.width) {
        resultSize = CGSizeMake(size.width, size.width*originSize.height/originSize.width);
    }
    if (ratio < 1 && originSize.height >= size.height) {
        resultSize = CGSizeMake(originSize.width*size.height/originSize.height, size.height);
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

+ (void)compressImages:(NSArray<UIImage *> *)images toSize:(CGSize)size referenceFileSize:(double)fileSize result:(void(^)(NSArray<NSData *> *resultImage))result {
    
    __block CGFloat compression = 1.f;
    CGFloat minCompression = 0.1;
    
    __block NSMutableArray *resultImages = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (UIImage *image in images) {
            
            UIImage *tempImage = [image scaleToSize:size];
            __block NSData *imageData = UIImageJPEGRepresentation(tempImage, compression);

            while (imageData.length > fileSize && compression > minCompression) {
                compression -= 0.1;
                imageData = UIImageJPEGRepresentation(tempImage, compression);
            }
            [resultImages addObject:imageData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            result(resultImages);
        });
    });
}

@end
