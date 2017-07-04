//
//  UIApplication+version.m
//  JUtils
//
//  Created by Neo on 2017/4/24.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "UIApplication+version.h"

@implementation UIApplication (version)

- (void)ver_openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion {    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_3
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [self openURL:url options:options completionHandler:^(BOOL success) {
            completion(success);
        }];
    } else {
        completion([self openURL:url]);
    }
#else 
        completion([self openURL:url]);
#endif
}

@end
