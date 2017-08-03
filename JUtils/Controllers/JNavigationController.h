//
//  NavigationViewController.h
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNavigationController : UINavigationController

@property (nonatomic, strong) NSDictionary *titleTextAttributes;

@property (nonatomic, strong) UIColor *navigationBarBackgroundColor;

/**
 enableGestureRecognizer 手势返回开关 
 */
@property (nonatomic, assign) BOOL enableGestureRecognizer;

@end
