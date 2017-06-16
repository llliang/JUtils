//
//  JAutoResizeTextView.h
//  JUtils
//
//  Created by Neo on 2017/6/16.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JPlaceholderTextView.h"

@protocol JAutoResizeTextViewDelegate <NSObject>

- (void)autoResizeTextViewFrameChanged:(CGRect)textViewRect;

@end

typedef void(^TextViewFrameChanged)(UITextView *textView, CGRect rect);


@interface JAutoResizeTextView : JPlaceholderTextView

/// 限制字数行数
@property(nonatomic) NSInteger numberOfLines;

@property (nonatomic) TextViewFrameChanged frameChanged;
@property (nonatomic) id<JAutoResizeTextViewDelegate> resizeDelegate;

@end
