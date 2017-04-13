//
//  HttpScrollViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHttpRefreshScrollViewController.h"
#import "JRefreshView.h"
#import "UIView+frame.h"

@interface JHttpRefreshScrollViewController () <JRefreshViewDelegate> {
    JRefreshView *_refreshView;
    UIView *_noDataView;
}

@end

@implementation JHttpRefreshScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _containerView = [[[self getContainerViewClass] alloc] initWithFrame:self.view.bounds];
    if (![_containerView isKindOfClass:[UIScrollView class]]) {
        NSAssert(NO, @"容器类不是UIScrollView子类");
    }
    _containerView.delegate = self;
    [self.view addSubview:_containerView];
    
    _refreshView = [[JRefreshView alloc] initWithFrame:CGRectMake(0, -60, _containerView.width, 60)];
    _refreshView.delegate = self;
    [_containerView addSubview:_refreshView];
    
    _noDataView = [self createNoDataView];
    [self.view addSubview:_noDataView];
    
    _noDataView.hidden = YES;
    
    _dataModel = [self createDataModel];
    if (_dataModel.data && [_dataModel.data count]) {
        if ([_containerView respondsToSelector:@selector(reloadData)]) {
            [_containerView performSelector:@selector(reloadData)];
        }
    }
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.01];
}

- (UIView *)createNoDataView {
    return  [[UIView alloc] initWithFrame:_containerView.bounds];
}

- (void)loadData {
    [_dataModel loadStart:^{
        
    } finished:^(JDataModel *model) {
        [self loadSuccess:YES];
    } failure:^(NSError *error) {
        [self loadSuccess:NO];
    }];
}

// 加载完成
- (void)loadSuccess:(BOOL)success {
 
    [_refreshView refreshScrollViewDataSourceDidFinishedLoading:_containerView];
    
    if (success) {
        _noDataView.hidden = !(_dataModel.data && [_dataModel.data count]);
    }else {
        _noDataView.hidden = YES;
    }
    
    if ([_containerView respondsToSelector:@selector(reloadData)]) {
        [_containerView performSelector:@selector(reloadData)];
    }
}

- (void)refreshData {
    self.dataModel.isReload = YES;
    [self loadData];
}


#pragma mark ---------- 子类需重写的方法
// 此方法子类可重载
- (Class)getContainerViewClass {
    return [UIScrollView class];
}

- (JDataModel *)createDataModel {
    JDataModel *dataModel = [[JDataModel alloc] init]; 
    return dataModel;
}

#pragma mark -------- container View delegate && data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshView refreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -------- refreshView  delegate

- (void)pullRefreshTableHeaderDidTriggerRefresh:(JRefreshView *)view {
    [self refreshData];
}

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(JRefreshView *)view {
    return  self.dataModel.loading;
}

@end