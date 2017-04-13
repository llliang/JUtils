//
//  JOnePixLineView.h
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JOnePixLineModeHorizontal = 0,
    JOnePixLineModeVertical,
}JOnePixLineMode;

@interface JOnePixLineView : UIView


@property (nonatomic, assign) JOnePixLineMode mode;
@property (nonatomic, strong) UIColor *lineColor;

@end
