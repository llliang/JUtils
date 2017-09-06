//
//  UIAlertController+block.m
//  JUtils
//
//  Created by Neo on 2017/9/6.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "UIAlertController+block.h"

@implementation UIAlertController (block)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actions cancelButtonTitle:(NSString *)cancelTitle preferredStyle:(UIAlertControllerStyle)preferredStyle clickedIndex:(void(^)(NSInteger index))actionHandler {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    for (NSInteger i = 0; i < actions.count; i++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:actions[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            actionHandler(i);
        }];
        
        [controller addAction:action];
    }
    if (cancelTitle && cancelTitle.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [controller addAction:cancelAction];
    }
    return controller;
}

@end
