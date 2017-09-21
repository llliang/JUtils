//
//  HttpRefreshLoadMoreScrollViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JPullRefreshLoadMoreTableViewController.h"
#import "UIView+frame.h"

@interface JPullRefreshLoadMoreTableViewController () <JLoadMoreViewDelegate> {
    
}

@end

@implementation JPullRefreshLoadMoreTableViewController

- (void)viewDidLoad {
    _loadMoreView = [self createLoadMoreView];
    
    [super viewDidLoad];
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
        if (self.dataModel.canLoadMore && self.tableView.contentSize.height >= self.tableView.height + _loadMoreView.height) {
            self.tableView.tableFooterView = _loadMoreView;
        } else {
            self.tableView.tableFooterView = nil;
        }
    } else {
        [_loadMoreView setState:JLoadMoreViewStateFailed];
        if (self.dataModel.itemCount >= self.dataModel.fetchLimited) {
            self.tableView.tableFooterView = _loadMoreView;
        } else {
            self.tableView.tableFooterView = nil;
        }
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
    
    if (!self.dataModel.loading && self.dataModel.canLoadMore) {
        [_loadMoreView scrollViewDidEndDragging:scrollView];
    }
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

