//
//  JLoopScrollView.m
//  JUtils
//
//  Created by Neo on 2017/6/13.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JLoopScrollView.h"
#import "UIView+frame.h"
#import "JUtil.h"
#import "UIView+animation.h"

@interface JLoopScrollView () <UIScrollViewDelegate> {
    
    UIScrollView *_scrollView;
    NSInteger _repeatTimes;     /// 重复次数
    NSTimer *_loopTimer;        /// 循环滚动定时器
    CGFloat _loopDuration;      /// 每次滚动所用时间
    NSInteger _currentIndex;    /// 当前位置
    
    UIPageControl *_pageControl;
}

@end

@implementation JLoopScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _loopInterval = 3.0f;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 20, [JUtil screenWidth], 20)];
        [self addSubview:_pageControl];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor?self.currentPageIndicatorTintColor:[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor?self.pageIndicatorTintColor:[UIColor grayColor];
    }
    return self;
}

- (void)setItemViewList:(NSArray *)itemViewList {
    [self setItemViewList:itemViewList animated:NO];
}

- (void)setItemViewList:(NSArray *)itemViewList animated:(BOOL)animated {
    if (itemViewList && itemViewList.count > 1) {
        _pageControl.hidden = NO;
    } else {
        _pageControl.hidden = YES;
    }
    
    [_itemViewList makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    _loopDuration = 0;
    
    _itemViewList = itemViewList;
    for (UIView *itemView in _itemViewList) {
        [_scrollView addSubview:itemView];
    }
    
    _pageControl.numberOfPages = itemViewList.count;
    [self bringSubviewToFront:_pageControl];
    
    _scrollView.contentSize = CGSizeMake(self.width*_itemViewList.count*1000, self.height);
    _scrollView.contentOffset = CGPointMake(self.width*_itemViewList.count*500, 0);
    [self updateLayout];
    
    if (_itemViewList.count > 1) {
        _scrollView.scrollEnabled = YES;
    } else {
        _scrollView.scrollEnabled = NO;
    }
    
    if (animated) {
        [self startFadeTransition];
    }
}

- (void)setEnableAlphaAnimation:(BOOL)enableAlphaAnimation {
    _enableAlphaAnimation = enableAlphaAnimation;
    if (_enableAlphaAnimation) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, self.width, self.height);
        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
                           (id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor,
                           (id)[UIColor clearColor].CGColor,nil];
        gradient.startPoint = CGPointMake(0.0f, 0.5f);
        gradient.endPoint = CGPointMake(1.0f, 0.5f);
        gradient.locations = @[@(0.0f),@(0.2f),@(0.8f),@(1.0f)];
        self.layer.mask = gradient;
    } else {
        self.layer.mask = nil;
    }
}

- (void)updateLayout {
    if (_itemViewList.count == 0) {
        return;
    };
    
    int totalIndex = floorf(_scrollView.contentOffset.x/self.width);
    int index = totalIndex%_itemViewList.count;
    
    for (int i = 0; i < _itemViewList.count; i++) {
        NSInteger ri = i+index;
        if (ri >= _itemViewList.count) {
            
            ri = ri-_itemViewList.count;
        }
        
        float left = (totalIndex + i) * self.width;
        [_itemViewList[ri] setLeft:left];
        
        if (_enableAlphaAnimation) {
            
            [_itemViewList[ri] setAlpha:MAX(0, 1 - fabs(_scrollView.contentOffset.x - left)/(self.width/4 * 3))];
        }
    }
    
    if (_currentIndex != self.currentIndex) {
        
        _currentIndex = self.currentIndex;
        [_loopDelegate loopScrollView:self didChangeIndex:_currentIndex];
    }
    _pageControl.currentPage = self.currentIndex;
}

- (NSInteger)currentIndex {
    if (_itemViewList.count == 0) {
        return 0;
    }
    if (((int)_scrollView.contentOffset.x)%((int)self.width) > self.width/2) {
        
        return (int)ceilf(_scrollView.contentOffset.x/self.width) % _itemViewList.count;
    } else {
        
        return (int)floorf(_scrollView.contentOffset.x/self.width) % _itemViewList.count;
    }
}

- (void)startAutoLoopWithRepeatTimes:(NSInteger)times {
    _repeatTimes = times;
    
    if (![_loopTimer isValid]) {
        _loopDuration = 0;
        _loopTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(loopTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_loopTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopAutoLoop {
    [_loopTimer invalidate];
    _loopTimer = nil;
}

- (void)loopTimerAction {
    if (_itemViewList.count <= 1) {
        [_loopTimer invalidate];
        return;
    }
    if (_scrollView.isDragging || _scrollView.isDecelerating || _scrollView.isZooming || _scrollView.isZoomBouncing) {
        _loopDuration = 0;
        return;
    }
    _loopDuration += 1;
    
    if (_loopDuration > _loopInterval) {
        _loopDuration = 0;
        NSInteger index = self.currentIndex;
        if (index == (_itemViewList.count - 1)) {
            _repeatTimes--;
        }
        [_scrollView setContentOffset:CGPointMake((500 * _itemViewList.count + index) * self.width, 0) animated:NO];
        [_scrollView setContentOffset:CGPointMake(self.width * (500 * _itemViewList.count + index + 1), 0) animated:YES];
        if (_repeatTimes <= 0) {
            [_loopTimer invalidate];
        }
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateLayout];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float of = _scrollView.contentOffset.x - _itemViewList.count * 500 * self.width;
    
    if (of > (_itemViewList.count * self.width * 50)) {
        
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x - _itemViewList.count * self.width * 50, 0);
    } else if (of < 0 - _itemViewList.count * self.width * 50) {
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + _itemViewList.count * self.width * 50, 0);
    }
}

@end
