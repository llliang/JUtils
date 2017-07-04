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
        _placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        [self addSubview:_placeholderView];

        [self setupPlaceholderView];
        [self addTextChangedNotification];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _placeholderView = [[UITextView alloc] init];
        [self addSubview:_placeholderView];
        
        [self setupPlaceholderView];
        [self addTextChangedNotification];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _placeholderView.frame = self.bounds;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeForPlaceholder:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setupPlaceholderView {
    _placeholderView.userInteractionEnabled = NO;
    _placeholderView.font = self.font;
    _placeholderView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    _placeholderView.showsVerticalScrollIndicator = NO;
    _placeholderView.showsHorizontalScrollIndicator = NO;
    _placeholderView.scrollEnabled = NO;
    _placeholderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderView];
}

// 解决直接设置text UITextViewTextDidChangeNotification 不调用的问题
- (void)setText:(NSString *)text {
    [super setText:text];
    if (text == nil || [text isEqualToString:@""]) {
        _placeholderView.hidden = NO;
    } else {
        _placeholderView.hidden = YES;
    }
}

- (void)textDidChangeForPlaceholder:(NSNotification *)notification {
    _placeholderView.hidden = (self.text && self.text.length > 0);
}

@end
