//
//  UIAlertController+block.h
//  JUtils
//
//  Created by Neo on 2017/9/6.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (block)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actions cancelButtonTitle:(NSString *)cancelTitle preferredStyle:(UIAlertControllerStyle)preferredStyle clickedIndex:(void(^)(NSInteger index))actionHandler;

@end
