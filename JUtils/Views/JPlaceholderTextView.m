//
//  JPlaceholderTextView.m
//  JUtils
//
//  Created by Neo on 2017/6/16.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JPlaceholderTextView.h"

@interface JPlaceholderTextView () {
    // 用textView 作为占位符容器 可完美解决 字体大小 重叠等问题
    UITextView *_placeholderView;
}

@end

@implementation JPlaceholderTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderView = [[UITextView alloc] initWithFrame:frame];
        [self layoutPlaceholderView];
        [self addTextChangedNotification];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _placeholderView = [[UITextView alloc] init];
        [self layoutPlaceholderView];
        [self addTextChangedNotification];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _placeholderView.frame = frame;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderView.font = font;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderView.text = placeholder;
}

- (void)addTextChangedNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)layoutPlaceholderView {
    _placeholderView.font = self.font;
    _placeholderView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    _placeholderView.showsVerticalScrollIndicator = NO;
    _placeholderView.showsHorizontalScrollIndicator = NO;
    _placeholderView.scrollEnabled = NO;
    _placeholderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderView];
}

- (void)textDidChange:(NSNotification *)notification {
    _placeholderView.hidden = (self.text && self.text.length > 0);
}

@end