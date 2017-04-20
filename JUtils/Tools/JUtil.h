//
//  Util.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JUtil : NSObject

// 获取设备uuid
+ (NSString *)getCurrentDeviceUUID;

// 系统版本
+ (CGFloat)systemVersion;

// app 版本
+ (NSString *)appVersion;

// 屏幕高度、宽度 point
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

// 沙盒 document root path
+ (NSString *)getDocumentRootPath;

/**
 简单判断手机号码 1开头 11位 根据需要可重新写
 */
+ (BOOL)checkPhone:(NSString *)phone;

// 
@end
