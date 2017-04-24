//
//  UIApplication+version.h
//  JUtils
//
//  Created by Neo on 2017/4/24.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (version)

- (void)ver_openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL success))completion;

@end
