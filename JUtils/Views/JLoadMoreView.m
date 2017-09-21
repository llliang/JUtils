//
//  LoadMoreTableViewCell.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JLoadMoreView.h"
#import "JUtil.h"
#import "UIView+frame.h"
#import "UIColor+hex.h"

@interface JLoadMoreView () {
    UIActivityIndicatorView *_aiView;
    UILabel *_loadingLabel;
    UILabel *_normalLabel;
    UIButton *_failureBtn;
}

@end

@implementation JLoadMoreView

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, [JUtil screenWidth], 44)];
    if (self) {
        
        _aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _aiView.transform = CGAffineTransformMakeScale(18.0f/_aiView.width, 18.0f/_aiView.width);
        [self addSubview:_aiView];
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.font = [UIFont systemFontOfSize:13];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.text = @"加载中...";
        
        _loadingLabel.textColor = [UIColor colorWithHexString:@"73d38e" alpha:1];
        [_loadingLabel sizeToFit];
        [self addSubview:_loadingLabel];
        
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalLabel.font = [UIFont systemFontOfSize:13];
        _normalLabel.backgroundColor = [UIColor clearColor];
        _normalLabel.text = @"上拉加载更多";
        _normalLabel.textColor = [UIColor colorWithHexString:@"73d38e" alpha:1];
        [_normalLabel sizeToFit];
        [self addSubview:_normalLabel];
        
        _failureBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [_failureBtn addTarget:self action:@selector(startLoad) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_failureBtn];
        _failureBtn.hidden = YES;
        
        _loadingLabel.baselineAdjustment = _normalLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        
        _normalLabel.origin = CGPointMake([JUtil screenWidth]/2 - _normalLabel.width/2,self.height/2 - _normalLabel.height/2);
        _aiView.origin = CGPointMake([JUtil screenWidth]/2 - (4 + _aiView.width + _loadingLabel.width)/2, self.height/2 - _aiView.height/2);
        _loadingLabel.origin = CGPointMake(_aiView.right + 4, self.height/2 - _loadingLabel.height/2);
        
        [self setState:JLoadMoreViewStateNormal];
    }
    return self;
}

- (void)setState:(JLoadMoreViewState)state {
    _state = state;
    _failureBtn.hidden = state != JLoadMoreViewStateFailed;
    switch (state) {
        case JLoadMoreViewStateNormal: {
            [_aiView stopAnimating];
            _normalLabel.hidden = NO;
            _normalLabel.text = @"上拉加载更多";
            _aiView.hidden = YES;
            _loadingLabel.hidden = YES;
        }
            break;
        case JLoadMoreViewStateFailed: {
            _normalLabel.hidden = NO;
            _normalLabel.text = @"点击加载更多";
            [_aiView stopAnimating];
            _aiView.hidden = YES;
            _loadingLabel.hidden = YES;
        }
            break;
        default: {
            _normalLabel.hidden = YES;
            [_aiView startAnimating];
            _aiView.hidden = NO;
            _loadingLabel.hidden = NO;
        }
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y - scrollView.contentInset.bottom >= scrollView.contentSize.height - scrollView.height) {
        if (self.state == JLoadMoreViewStateNormal) {
            self.state = JLoadMoreViewStateLoading;
        }
    }
    BOOL loading = [_delegate loadMoreViewIsLoading:self]; 
    if (!loading && self.state == JLoadMoreViewStateLoading && !scrollView.isDragging) {
        [_delegate loadMoreViewDidStartLoad:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y - scrollView.contentInset.bottom >= scrollView.contentSize.height - scrollView.height) {
        if (self.state == JLoadMoreViewStateNormal){
            self.state = JLoadMoreViewStateLoading;
        }
    }
    BOOL loading = [_delegate loadMoreViewIsLoading:self]; 
    if (!loading && self.state == JLoadMoreViewStateLoading) {
        [_delegate loadMoreViewDidStartLoad:self];
    }
}

- (void)startLoad {
    self.state = JLoadMoreViewStateLoading;
    [_delegate loadMoreViewDidStartLoad:self];
}

@end

