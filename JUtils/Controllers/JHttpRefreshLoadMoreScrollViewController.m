//
//  HttpRefreshLoadMoreScrollViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHttpRefreshLoadMoreScrollViewController.h"
#import "UIView+frame.h"

@interface JHttpRefreshLoadMoreScrollViewController () <JLoadMoreViewDelegate> {
    
}

@end

@implementation JHttpRefreshLoadMoreScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadMoreView = [self createLoadMoreView];
    [self.containerView addSubview:_loadMoreView];
    _loadMoreView.hidden = YES;
}

- (JLoadMoreView *)createLoadMoreView {
    JLoadMoreView *loadMoreView = [[JLoadMoreView alloc] init];
    loadMoreView.delegate = self;
    return loadMoreView;
}

- (void)loadSuccess:(BOOL)success {
    [super loadSuccess:success];
    
    if (success) {
        [_loadMoreView setState:JLoadMoreViewStateNormal];
        _loadMoreView.hidden = (self.containerView.contentSize.height > self.containerView.height) && self.dataModel.canLoadMore;
        _loadMoreView.top = self.containerView.contentSize.height;
    } else {
        [_loadMoreView setState:JLoadMoreViewStateFailed];
    }
    
    if (self.dataModel.canLoadMore) {
        self.containerView.contentSize = CGSizeMake(self.containerView.width, self.containerView.contentSize.height + _loadMoreView.height);
        _loadMoreView.top = self.containerView.contentSize.height;
    }
}

#pragma mark ------- container view delegate && data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    if (!self.dataModel.loading && self.dataModel.canLoadMore) {
        [_loadMoreView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    [_loadMoreView scrollViewDidEndDragging:scrollView];
}

#pragma mark --------- load more cell delegate

- (void)loadMoreViewDidStartLoad:(JLoadMoreView *)view {
    if (!self.dataModel.loading && self.dataModel.canLoadMore) {
        [self loadData];
    }
}

- (BOOL)loadMoreViewIsLoading:(JLoadMoreView *)view {
    return  self.dataModel.loading;
}

@end
