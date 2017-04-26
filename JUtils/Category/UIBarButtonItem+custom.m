//
//  UIBarButtonItem+custom.m
//  JUtils
//
//  Created by Neo on 2017/4/19.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "UIBarButtonItem+custom.h"
#import "UIView+frame.h"
#import "NSString+size.h"

@implementation UIBarButtonItem (custom)


+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action imageEdgeInsets:(UIEdgeInsets)edgeInsets {
    UIButton *button = [self barButtonWithTitle:nil target:target action:action];
    button.imageEdgeInsets = edgeInsets;
    [button setImage:image forState:UIControlStateNormal];
    button.width = image.size.width + 10;
    button.exclusiveTouch = YES;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action titleEdgeInsets:(UIEdgeInsets)edgeInsets {
    UIButton *btn = [self barButtonWithTitle:title target:target action:action];
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = edgeInsets;
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    btn.exclusiveTouch = YES;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIButton *)barButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat buttonWidth = [title sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    btn.width = MIN(buttonWidth+10, 100);
    btn.height = 44;
    btn.exclusiveTouch = YES;
    return btn;
}

@end
