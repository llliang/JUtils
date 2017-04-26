//
//  UIBarButtonItem+custom.h
//  JUtils
//
//  Created by Neo on 2017/4/19.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (custom)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action imageEdgeInsets:(UIEdgeInsets)edgeInsets;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action titleEdgeInsets:(UIEdgeInsets)edgeInsets;


@end
