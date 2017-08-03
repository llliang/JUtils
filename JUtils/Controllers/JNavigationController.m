//
//  NavigationViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JNavigationController.h"
#import "UIImage+tool.h"
#import "UIColor+hex.h"

@interface JNavigationController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation JNavigationController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBar.translucent = NO;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 清除默认shadow
    [self removeDefaultShadow];
    
    // navigation bar 背景色
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff" alpha:0.7] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = [UIColor clearColor];
    //设置navigationBar的标题的颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"000000" alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16],NSShadowAttributeName:shadow};
}

- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes {
    _titleTextAttributes = titleTextAttributes;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.navigationBar.titleTextAttributes];
    
    [titleTextAttributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setObject:obj forKey:key];
    }];
    
    self.navigationBar.titleTextAttributes = dic;
}

- (void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    _navigationBarBackgroundColor = navigationBarBackgroundColor;
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:navigationBarBackgroundColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
}

- (void)removeDefaultShadow {
    if (self.navigationBar.subviews.count>0&&[self.navigationBar.subviews[0] subviews].count>0) {
        for (UIView *view in [self.navigationBar.subviews[0] subviews]) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view setHidden:YES];
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count<=1) {
        return NO;
    }
    return self.enableGestureRecognizer;
}

@end
