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
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"73d38e" alpha:1] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    //设置navigationBar的标题的颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff" alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:[UIColor clearColor]};
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
    return YES;
}

@end
