//
//  JAutoResizeTextView.m
//  JUtils
//
//  Created by Neo on 2017/6/16.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JAutoResizeTextView.h"

@interface JAutoResizeTextView () {
    CGFloat _maxTextHeight;
}

@end

@implementation JAutoResizeTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.scrollsToTop = NO;
    self.scrollEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    
    // default font
    self.font = [UIFont systemFontOfSize:14];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self calculateMaxTextHeight];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self calculateMaxTextHeight];
}

- (void)calculateMaxTextHeight {
    
    _maxTextHeight = ceil(self.font.lineHeight * _numberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)textDidChange:(NSNotification *)notification {

    double height = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    
    if (_numberOfLines > 0 && height >= _maxTextHeight) {
        self.scrollEnabled = YES;
        return; 
    }
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    if ([_resizeDelegate respondsToSelector:@selector(autoResizeTextViewFrameChanged:)]) {
        [_resizeDelegate autoResizeTextViewFrameChanged:newFrame];
    }
    if (_frameChanged) {
        _frameChanged(self, newFrame);
    }
}

@end
