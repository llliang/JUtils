//
//  RefreshView.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JRefreshView.h"
#import "UIView+frame.h"
#import "UIColor+hex.h"

static const CGFloat OFFSET_Min = 70; // 触发refresh 最小偏移量

@interface JRefreshView () {
    UILabel *_tLabel;
}

@end

@implementation JRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _tLabel.textAlignment = NSTextAlignmentCenter;
        _tLabel.font = [UIFont systemFontOfSize:12];
        _tLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tLabel.textColor = [UIColor colorWithHexString:@"353535" alpha:1];
        [self addSubview:_tLabel];
        self.state = RefreshStateNormal;
    }
    return self;
}

// 若需要自定义 refresh animation  只需要重载这个就好
- (void)setState:(RefreshState)state {    
    switch (state) {
        case RefreshStateNormal:
            _tLabel.text = @"下拉刷新";
            break;
        case RefreshViewPullingCanRefresh:
            _tLabel.text = @"松开即可刷新";
            break;
        case RefreshStateLoading:
            _tLabel.text = @"正在刷新...";
            break;
        default:
            break;
    }
    _state = state;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_state == RefreshStateLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, self.height);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
        
    } else if (scrollView.isDragging) {
        
        CGFloat offset_y = scrollView.contentOffset.y;

        if (offset_y >= 0) {
            return;
        }
        
        BOOL loading = NO;
        if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDataSourceIsLoading:)]) {
            loading = [_delegate pullRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        if (!loading) {
            if (offset_y > -OFFSET_Min) {
                if (_state != RefreshStateNormal) {
                    self.state = RefreshStateNormal;
                }
            }else{
                self.state = RefreshViewPullingCanRefresh;
            }
        }
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    CGFloat offset_y = scrollView.contentOffset.y;
    if (offset_y >= 0) {
        return;
    }
    
    BOOL loading = NO;
    
    if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDataSourceIsLoading:)]) {
        loading = [_delegate pullRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (!loading) {
        if (offset_y < -OFFSET_Min) {
            [UIView animateWithDuration:0.25 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(self.height, 0, 0, 0);  
            }];
            
            if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate pullRefreshTableHeaderDidTriggerRefresh:self];
            }
            self.state = RefreshStateLoading;
        } else {
            self.state = RefreshStateNormal;
        }
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(OFFSET_Min, 0, 0, 0);  
        }];
    }
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    }];
    self.state = RefreshStateNormal;
}

@end
