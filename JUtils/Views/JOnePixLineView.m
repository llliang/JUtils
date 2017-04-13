//
//  JOnePixLineView.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JOnePixLineView.h"
#import "UIColor+hex.h"
#import "UIView+frame.h"

@implementation JOnePixLineView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setMode:(JOnePixLineMode)mode {
    _mode = mode;
    if (mode == JOnePixLineModeHorizontal) {
        self.height = 1.f;
    } else {
        self.width = 1.f;
    }
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat bottomInset;
    if ([UIScreen mainScreen].scale > 1.0f) {
        bottomInset = 0.25;
    } else {
        bottomInset = 0.5;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 0.5);
    if (!_lineColor) {
        _lineColor = [UIColor grayColor];
    }
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    if (_mode == JOnePixLineModeHorizontal) {
        CGContextMoveToPoint(context, 0, CGRectGetHeight(rect)-bottomInset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-bottomInset);
    } else {
        CGContextMoveToPoint(context, CGRectGetWidth(rect)-bottomInset, 0);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect)-bottomInset, CGRectGetHeight(rect));
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
