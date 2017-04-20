//
//  Util.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JUtil.h"
#import <sys/utsname.h>

@implementation JUtil

+ (NSString *)getCurrentDeviceUUID {
    return [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
}

+ (CGFloat)systemVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)appVersion {
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (NSString *)getDocumentRootPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (BOOL)checkPhone:(NSString *)phone {
    // 简单判断11位 1开头的数字
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:@"^1[0-9]{10}$" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSInteger count = [regEx numberOfMatchesInString:phone options:NSMatchingReportProgress range:NSMakeRange(0, phone.length)];
    return count > 0;
}

@end
