//
//  JLoopScrollView.h
//  JUtils
//
//  Created by Neo on 2017/6/13.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLoopScrollView;

@protocol JLoopScrollViewDelegate <NSObject>

@optional

- (void)loopScrollView:(JLoopScrollView *)scrollView didChangeIndex:(NSInteger)index;

@end


@interface JLoopScrollView : UIView

@property (nonatomic, assign) id<JLoopScrollViewDelegate> loopDelegate;

@property (nonatomic, strong) NSArray *itemViewList;

@property (nonatomic, readonly) NSInteger currentIndex;

@property (nonatomic) BOOL enableAlphaAnimation;
@property (nonatomic) CGFloat loopInterval;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

- (void)setItemViewList:(NSArray *)itemViewList animated:(BOOL)animated;
- (void)startAutoLoopWithRepeatTimes:(NSInteger)times;
- (void)stopAutoLoop;

@end
